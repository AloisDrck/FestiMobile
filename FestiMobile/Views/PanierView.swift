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
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var bilanviewModel = BilanViewModel()
    
    @State private var showError = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    var jeuxMemeVendeur: [JeuDepot] {
        jeuDepotViewModel.jeux.filter { $0.vendeur == jeuDepot.vendeur }
    }
    
    var totalPanier: Double {
        panierViewModel.jeuxDansPanier.reduce(0) { $0 + ($1.prixJeu ?? 0) * Double($1.quantiteVendus) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
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
                                .swipeActions {
                                    Button(action: {
                                        panierViewModel.retirerDuPanier(jeuId: item.idJeuDepot)
                                    }) {
                                        Label("Supprimer", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                    
                    if !jeuxMemeVendeur.isEmpty {
                        Section(header: Text("Jeux du même vendeur").font(.headline)) {
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
                                    .disabled(panierViewModel.jeuxDansPanier.first(where: { $0.idJeuDepot == jeu.id })?.quantiteVendus ?? 0 >= jeu.quantiteJeuDisponible)
                                }
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
                            
                            Button(action: {
                                showSuccess.toggle()
                            }) {
                                Text("Valider l'achat")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                            }
                            .disabled(totalPanier == 0)
                        }
                    }
                }
                .cornerRadius(15)
                .shadow(radius: 5)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("Panier")
            .background(
                Image("panierBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
            .onAppear {
                panierViewModel.ajouterAuPanier(jeu: jeuDepot)
                jeuDepotViewModel.fetchJeuxEnStock()
                sessionViewModel.fetchSessionEnCours()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("❌ Erreur"), message: Text(errorMessage ?? "Une erreur est survenue"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Confirmer l'achat"),
                    message: Text("Total de l'achat: \(totalPanier, specifier: "%.2f") €"),
                    primaryButton: .destructive(Text("Confirmer")) {
                        finaliserAchat()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func finaliserAchat() {
        guard let utilisateurId = utilisateur.id else {
            errorMessage = "Erreur: L'utilisateur n'a pas d'ID valide."
            return
        }
        
        guard let session = sessionViewModel.session else {
            errorMessage = "Erreur: Aucune session en cours."
            return
        }
        
        let commision = (session.commission * totalPanier) / 100
        
        let vente = Vente(
            id: UUID().uuidString,
            acheteur: utilisateurId,
            vendeur: jeuDepot.vendeur,
            commissionVente: commision,
            dateVente: Date(),
            montantTotal: totalPanier
        )
        
        VenteViewModel().createVente(vente: vente, jeuxVendus: panierViewModel.jeuxDansPanier) { success in
            if success {
                // Utilisation du ViewModel pour récupérer le bilan du vendeur
                bilanviewModel.getBilanById(vendeurId: utilisateurId) { result in
                    switch result {
                    case .success(let bilan):
                        // Mettre à jour le bilan avec les nouvelles valeurs
                        guard let bilanId = bilan.id else {
                            print("Erreur: Bilan sans Id")
                            return
                        }
                        
                        bilanviewModel.updateBilan(
                            id: bilanId,
                            vendeurId: bilan.vendeurId,
                            sommeDues: bilan.sommeDues + commision,
                            totalFrais: bilan.totalFrais,
                            totalCommissions: bilan.totalCommissions + commision,
                            gains: bilan.gains + totalPanier
                        ) { updateResult in
                            switch updateResult {
                            case .success(let message):
                                print("Bilan mis à jour: \(message)")
                            case .failure(let error):
                                print("Erreur lors de la mise à jour du bilan: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        print("Erreur lors de la récupération du bilan: \(error.localizedDescription)")
                    }
                }
                for jeuPanier in panierViewModel.jeuxDansPanier {
                    print(jeuPanier)
                    jeuDepotViewModel.loadJeuDepotById(jeuId: jeuPanier.idJeuDepot) { jeu in
                        guard let jeu = jeu else { return } // Vérifie que le jeu est bien chargé
                        
                        let nouvelleQuantiteDisponible = max(jeu.quantiteJeuDisponible - jeuPanier.quantiteVendus, 0)
                        let nouvelleQuantiteVendue = jeu.quantiteJeuVendu + jeuPanier.quantiteVendus
                        guard let jeuId = jeu.id else { return }
                        jeuDepotViewModel.updateJeuDepot(
                            jeuId: jeuId,
                            updates: [
                                "quantiteJeuDisponible": nouvelleQuantiteDisponible,
                                "quantiteJeuVendu": nouvelleQuantiteVendue
                            ]
                        ) { result in
                            switch result {
                            case .success(let response):
                                // Gère la réponse
                                print("Mise à jour réussie: \(response)")
                            case .failure(let error):
                                // Gère l'erreur
                                print("Erreur lors de la mise à jour: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                panierViewModel.jeuxDansPanier.removeAll()
                successMessage = "Votre achat a bien été validé."
            } else {
                errorMessage = "La vente n'a pas pu être créée."
                showError = true
            }
        }
    }
}
