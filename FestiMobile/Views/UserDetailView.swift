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
    @State private var bilan: Bilan?
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Informations de l'utilisateur
                Text("\(utilisateur.nom) \(utilisateur.prenom)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                // Informations générales
                Group {
                    Text("Email: \(utilisateur.mail)")
                    Text("Rôle: \(utilisateur.role.rawValue.capitalized)")
                    
                    if let telephone = utilisateur.telephone {
                        Text("Téléphone: \(telephone)")
                    }
                    if let adresse = utilisateur.adresse {
                        Text("Adresse: \(adresse)")
                    }
                    if let ville = utilisateur.ville {
                        Text("Ville: \(ville)")
                    }
                    if let codePostal = utilisateur.codePostal {
                        Text("Code Postal: \(codePostal)")
                    }
                    if let pays = utilisateur.pays {
                        Text("Pays: \(pays)")
                    }
                }
                .font(.body)
                .foregroundColor(.secondary)
                
                // Récupération du bilan si c'est un vendeur
                if utilisateur.role == .vendeur {
                    VStack(alignment: .leading, spacing: 15) {
                        if isLoading {
                            ProgressView("Chargement du bilan...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.top)
                        } else if let bilan = bilan {
                            Text("Bilan du vendeur")
                                .font(.title2)
                                 .fontWeight(.bold)
                                 .foregroundColor(.primary)
                            
                            HStack {
                                  Text("Somme Dues:")
                                  Spacer()
                                  Text("\(bilan.sommeDues, specifier: "%.2f") €")
                                      .foregroundColor(.green)
                              }
                              
                              HStack {
                                  Text("Total des Frais:")
                                  Spacer()
                                  Text("\(bilan.totalFrais, specifier: "%.2f") €")
                                      .foregroundColor(.red)
                              }
                              
                              HStack {
                                  Text("Total des Commissions:")
                                  Spacer()
                                  Text("\(bilan.totalCommissions, specifier: "%.2f") €")
                                      .foregroundColor(.blue)
                              }
                              
                              HStack {
                                  Text("Gains:")
                                  Spacer()
                                  Text("\(bilan.gains, specifier: "%.2f") €")
                                      .foregroundColor(.orange)
                              }
                        } else if let error = error {
                            Text("Erreur : \(error.localizedDescription)")
                                .foregroundColor(.red)
                                .padding(.top)
                        }
                    }
                    .padding(.top)
                    .onAppear {
                        loadBilan()
                    }
                    Divider()
                }
                
                // Liste des jeux déposés pour un vendeur
                if utilisateur.role == .vendeur {
                    NavigationLink(destination: SellerDepotListView(userId: utilisateur.id)) {
                        Text("Liste des jeux déposés")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails de l'utilisateur")
        .background(Color(.systemGray6))
    }
    
    // Fonction pour charger le bilan du vendeur
    private func loadBilan() {
        if utilisateur.role == .vendeur {
            isLoading = true
            let vendeurId = utilisateur.id
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
}

