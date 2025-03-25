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
                    detailRow(title: "Nom :", value: jeu.nomJeu, valueColor: .primary)
                    detailRow(title: "Éditeur :", value: jeu.editeurJeu, valueColor: .secondary)
                    detailRow(title: "Prix :", value: String(format: "%.2f", jeu.prixJeu) + "€", valueColor: .green)
                    detailRow(title: "Quantité disponible :", value: "\(jeu.quantiteJeuDisponible)", valueColor: .primary)
                    detailRow(title: "Quantité vendue :", value: "\(jeu.quantiteJeuVendu)", valueColor: .primary)
                    detailRow(title: "Statut :", value: jeu.statutJeu.rawValue, valueColor: jeu.statutJeu == .disponible ? .green : .red)
                    
                    // Date de dépôt
                    HStack {
                        Text("Date de dépôt :")
                            .fontWeight(.semibold)
                        Spacer()
                        if let dateDepot = jeu.dateDepot {
                            Text(dateDepot, formatter: dateFormatter)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Aucune date")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    detailRow(title: "Frais de dépôt :", value:String(format: "%.2f", jeu.fraisDepot) + "€", valueColor: .blue)
                    detailRow(title: "Remise sur dépôt :", value: String(format: "%.2f", jeu.remiseDepot) + "%", valueColor: .blue)
                }
                .padding(.horizontal)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Détails du jeux")
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
            .padding(.bottom)
        }
    }
    
    private func detailRow(title: String, value: String, valueColor: Color) -> some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"  // Format personnalisé JJ/MM/AAAA
    return formatter
}()

