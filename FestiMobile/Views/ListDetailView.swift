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
                            Spacer()
                            Text(formattedDate(vente.dateVente))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Montant total :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(String(format: "%.2f €", vente.montantTotal))
                                .foregroundColor(.green)
                        }
                        
                        if utilisateur.role == .vendeur {
                            HStack {
                                Text("Commission :")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(String(format: "%.2f €", vente.commissionVente))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack {
                            Text("Acheteur :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(vente.acheteurNom ?? "Inconnu") \(vente.acheteurPrenom ?? "")")
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            Text("Vendeur :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(vente.vendeurNom ?? "Inconnu") \(vente.vendeurPrenom ?? "")")
                                .foregroundColor(.primary)
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
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
                        List(viewModel.jeuxVendus) { jeu in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    if let nom = jeu.nomJeu {
                                        Text(nom)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                                
                                if let editeur = jeu.editeurJeu {
                                    HStack {
                                        Text("Editeur :")
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(editeur)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                HStack {
                                    Text(utilisateur.role == .vendeur ? "Quantité vendue :" : "Quantité achetée :")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("\(jeu.quantiteVendus)")
                                        .foregroundColor(.secondary)
                                }
                                
                                if let prix = jeu.prixJeu {
                                    HStack {
                                        Text("Prix :")
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(String(format: "%.2f €", prix))
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.bottom, 8)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.top)
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchJeuxVendus(idVente: vente.id)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
