//
//  UserDetailView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct UserDetailView: View {
    @Binding var utilisateur: Utilisateur
    @StateObject private var viewModel = UtilisateurViewModel()
    @StateObject private var venteviewModel = VenteViewModel()
    @State private var bilan: Bilan?
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // En-tête utilisateur avec arrière-plan coloré
                VStack {
                    Text("\(utilisateur.nom) \(utilisateur.prenom)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(utilisateur.role.rawValue.capitalized)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                // Informations générales sous forme de carte
                infoCard(title: "Informations générales", content: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email: \(utilisateur.mail)")
                        if let telephone = utilisateur.telephone { Text("Téléphone: \(telephone)") }
                        if let adresse = utilisateur.adresse { Text("Adresse: \(adresse)") }
                        if let ville = utilisateur.ville { Text("Ville: \(ville)") }
                        if let codePostal = utilisateur.codePostal { Text("Code Postal: \(codePostal)") }
                        if let pays = utilisateur.pays { Text("Pays: \(pays)") }
                    }
                    .foregroundColor(.gray)
                })
                
                // Affichage du bilan pour les vendeurs
                if utilisateur.role == .vendeur {
                    infoCard(title: "Bilan", content: {
                        if isLoading {
                            ProgressView("Chargement du bilan...")
                        } else if let bilan = bilan {
                            VStack(alignment: .leading, spacing: 10) {
                                bilanRow(label: "Total des frais:", value: bilan.totalFrais, color: .red)
                                bilanRow(label: "Total des commissions:", value: bilan.totalCommissions, color: .blue)
                                bilanRow(label: "Somme dues:", value: bilan.sommeDues, color: .green)
                                bilanRow(label: "Gains:", value: bilan.gains, color: .orange)
                                bilanRow(label: "Montant final perçu:", value: bilan.gains - bilan.sommeDues, color: .pink)
                            }
                        } else if let error = error {
                            Text("Erreur : \(error.localizedDescription)").foregroundColor(.red)
                        }
                    })
                    .onAppear { loadBilan() }
                } else {
                    let nbAchat = venteviewModel.ventes.count
                    let sommeDepenses = venteviewModel.ventes.reduce(0.0) { $0 + $1.montantTotal }
                    infoCard(title: "Bilan", content: {
                        if isLoading {
                            ProgressView("Chargement du bilan...")
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Nombre d'achat")
                                    Spacer()
                                    Text("\(String(nbAchat))")
                                        .foregroundColor(.blue)
                                        .bold()
                                }
                                bilanRow(label: "Somme dépensés:", value: sommeDepenses, color: .green)
                            }
                        }
                    })
                    .onAppear {
                        guard let utilisateurId = utilisateur.id else { return }
                        venteviewModel.fetchVentes(id: utilisateurId, role: .acheteur)
                    }
                }
                
                HStack(spacing: 20) {
                    if utilisateur.role == .vendeur {
                        actionButton(icon: "gamecontroller.fill", backgroundColor: .blue, destination: SellerDepotListView(utilisateur: $utilisateur))
                        actionButton(icon: "cart.fill", backgroundColor: .green, destination: ListView(utilisateur: $utilisateur))
                        actionButton(icon: "arrow.down.circle.fill", backgroundColor: .purple, destination: DepotView(utilisateur: $utilisateur))
                    } else {
                        actionButton(icon: "cart.fill", backgroundColor: .blue, destination: ListView(utilisateur: $utilisateur))
                        actionButton(icon: "creditcard.fill", backgroundColor: .green, destination: AchatView(utilisateur: $utilisateur))
                    }
                }
                .padding(.top)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
            .navigationTitle("Détails de l'utilisateur")
        }
    }
    
    // Fonction pour charger le bilan
    private func loadBilan() {
        if utilisateur.role == .vendeur {
            isLoading = true
            guard let vendeurId = utilisateur.id else { return }
            BilanService.shared.getBilanById(vendeurId: vendeurId) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let fetchedBilan):
                        bilan = fetchedBilan
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
    
    // Composants réutilisables
    @ViewBuilder
    private func infoCard<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
    }
    
    private func bilanRow(label: String, value: Double, color: Color) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(String(format: "%.2f", value)) €")
                .foregroundColor(color)
                .bold()
        }
    }
    
    private func actionButton<Destination: View>(icon: String, backgroundColor: Color, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()  // Assure que l'icône garde ses proportions sans être déformée
                .frame(width: 50, height: 50)  // Taille de l'icône (ajustée selon ta préférence)
                .padding(20)  // Espace autour de l'icône dans le cercle
                .background(backgroundColor)
                .foregroundColor(.white)
                .clipShape(Circle())  // Cercle autour de l'icône
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)  // Centrer le bouton dans son parent
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Centrer le bouton sur l'écran
    }

}
