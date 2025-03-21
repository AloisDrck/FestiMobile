//
//  JeuDepotDetailView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct JeuDepotDetailView: View {
    let jeu: JeuDepot
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Détails du jeu
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        HStack {
                            Text("Éditeur :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(jeu.editeurJeu)
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Prix :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(jeu.prixJeu, specifier: "%.2f")€")
                                .foregroundColor(.green)
                        }

                        HStack {
                            Text("Quantité disponible :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(jeu.quantiteJeuDisponible)")
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Text("Quantité vendue :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(jeu.quantiteJeuVendu)")
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Text("Statut :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(jeu.statutJeu.rawValue)
                                .foregroundColor(jeu.statutJeu == .disponible ? .green : .red)
                        }

                        HStack {
                            Text("Date de dépôt :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(jeu.dateDepot, formatter: dateFormatter)
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Frais de dépôt :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(jeu.fraisDepot, specifier: "%.2f")€")
                                .foregroundColor(.blue)
                        }

                        HStack {
                            Text("Remise sur dépôt :")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(jeu.remiseDepot, specifier: "%.2f")%")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Bouton Fermer
                Spacer()
                
                Button("Fermer") {
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Détails du jeu")
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            .padding(.bottom)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
