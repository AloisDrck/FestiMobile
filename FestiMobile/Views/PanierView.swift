//
//  PanierView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 21/03/2025.
//


import SwiftUI

struct PanierView: View {
    @Binding var utilisateur: Utilisateur
    var jeuDepot: JeuDepot
    @StateObject private var panierViewModel = PanierViewModel()
    @StateObject private var jeuDepotViewModel = JeuDepotViewModel()
    
    @State private var showError = false  // Pour afficher l'alerte d'erreur
    @State private var showSuccess = false  // Pour afficher l'alerte de succès
    @State private var errorMessage: String? // Le message d'erreur à afficher
    @State private var successMessage: String? // Le message de succès à afficher
    @Environment(\.dismiss) private var dismiss  // Pour revenir à la vue précédente
    
    var jeuxMemeVendeur: [JeuDepot] {
        jeuDepotViewModel.jeux.filter { $0.vendeur == jeuDepot.vendeur && $0.id != jeuDepot.id }
    }
    
    var totalPanier: Double {
        panierViewModel.jeuxDansPanier.reduce(0) { $0 + ($1.prixJeu ?? 0) * Double($1.quantiteVendus) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // 🛒 Section : Jeux dans le panier
                    Section(header: Text("🛒 Votre panier").font(.headline)) {
                        ForEach(panierViewModel.jeuxDansPanier) { item in
                            if let jeuCorrespondant = jeuDepotViewModel.jeux.first(where: { $0.id == item.idJeuDepot }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.nomJeu ?? "Jeu inconnu")
                                            .font(.headline)
                                        Text("\(item.prixJeu ?? 0, specifier: "%.2f")€")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Stepper(value: Binding(
                                        get: { item.quantiteVendus },
                                        set: { newValue in
                                            panierViewModel.modifierQuantite(jeuId: item.idJeuDepot, nouvelleQuantite: newValue)
                                        }
                                    ), in: 1...jeuCorrespondant.quantiteJeuDisponible) {
                                        Text("x\(item.quantiteVendus)")
                                    }
                                    .disabled(jeuCorrespondant.quantiteJeuDisponible == 0)
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let jeu = panierViewModel.jeuxDansPanier[index]
                                panierViewModel.retirerDuPanier(jeuId: jeu.idJeuDepot)
                            }
                        }
                    }
                    
                    // 🎮 Section : Autres jeux du même vendeur
                    if !jeuxMemeVendeur.isEmpty {
                        Section(header: Text("Autres jeux du même vendeur").font(.headline)) {
                            ForEach(jeuxMemeVendeur) { jeu in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(jeu.nomJeu)
                                            .font(.headline)
                                        Text("\(jeu.prixJeu, specifier: "%.2f")€")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: { panierViewModel.ajouterAuPanier(jeu: jeu) }) {
                                        Image(systemName: "cart.badge.plus")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    // 💰 Section : Total du panier et bouton d'achat
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Total :")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text("\(totalPanier, specifier: "%.2f")€")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                            
                            Button(action: finaliserAchat) {
                                Text("Valider l'achat")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(totalPanier > 0 ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(totalPanier == 0)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Panier")
            .onAppear {
                panierViewModel.ajouterAuPanier(jeu: jeuDepot)
                jeuDepotViewModel.fetchJeux()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("❌ Erreur"), message: Text(errorMessage ?? "Une erreur est survenue"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showSuccess) {
                Alert(title: Text("🎉 Succès"), message: Text(successMessage ?? "La vente a été créée avec succès."), dismissButton: .default(Text("OK")) {
                    dismiss()  // Revenir à la vue précédente après l'alerte de succès
                })
            }
        }
    }
    
    private func finaliserAchat() {
        let vente = Vente(
            id: UUID().uuidString,
            acheteur: utilisateur.id,
            vendeur: jeuDepot.vendeur,
            commissionVente: 0.1, // TODO : mettre la commission correspondant à la session
            dateVente: Date(),
            montantTotal: totalPanier
        )
        
        VenteViewModel().createVente(vente: vente, jeuxVendus: panierViewModel.jeuxDansPanier) { success in
            if success {
                panierViewModel.jeuxDansPanier.removeAll()
                jeuDepotViewModel.fetchJeux()
                
                successMessage = "Votre achat a bien été validé."
                showSuccess = true
            } else {
                errorMessage = "La vente n'a pas pu être créée."
                showError = true
            }
        }
    }
}
