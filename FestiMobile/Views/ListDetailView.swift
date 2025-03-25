//
//  ListDetailView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 19/03/2025.
//

import SwiftUI

struct ListDetailView: View {
    var vente: Vente
    @StateObject private var viewModel = VenteJeuViewModel()
    @Binding var utilisateur: Utilisateur

    var body: some View {
        NavigationView {
            VStack {
                // Détails de la vente
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        HStack {
                            Text("Date :")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(formattedDate(vente.dateVente))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Montant total :")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(String(format: "%.2f €", vente.montantTotal))
                                .foregroundColor(.green)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        if utilisateur.role == .vendeur {
                            HStack {
                                Text("Commission :")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(String(format: "%.2f €", vente.commissionVente))
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        HStack {
                            Text("Acheteur :")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(vente.acheteurNom ?? "Inconnu") \(vente.acheteurPrenom ?? "")")
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            Text("Vendeur :")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(vente.vendeurNom ?? "Inconnu") \(vente.vendeurPrenom ?? "")")
                                .foregroundColor(.primary)
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Liste des jeux vendus
                    if viewModel.isLoading {
                        ProgressView("Chargement des jeux...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Section(header: Text("Jeux vendus lors de la vente")
                            .font(.headline)
                            .padding(.horizontal) ) {
                            List(viewModel.jeuxVendus) { jeu in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        if let nom = jeu.nomJeu {
                                            Text(nom)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                        Image(systemName: "gamecontroller")
                                            .foregroundColor(.blue)
                                    }
                                    
                                    if let editeur = jeu.editeurJeu {
                                        HStack {
                                            Text("Editeur :")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text(editeur)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    HStack {
                                        Text(utilisateur.role == .vendeur ? "Quantité vendue :" : "Quantité achetée :")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(jeu.quantiteVendus)")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if let prix = jeu.prixJeu {
                                        HStack {
                                            Text("Prix :")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text(String(format: "%.2f €", prix))
                                                .foregroundColor(.green)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                        }
                                    }
                                }
                                .cornerRadius(12)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                }
                .padding(.top)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .onAppear {
                viewModel.fetchJeuxVendus(idVente: vente.id)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Détails de la vente")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Image("popupBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
