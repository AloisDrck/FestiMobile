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
        VStack(spacing: 15) {
            Text(jeu.nomJeu)
                .font(.title)
                .bold()
            
            Text("Éditeur: \(jeu.editeurJeu)")
                .font(.headline)
            
            Text("Prix: \(jeu.prixJeu, specifier: "%.2f")€")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Quantité disponible: \(jeu.quantiteJeuDisponible)")
            Text("Quantité vendue: \(jeu.quantiteJeuVendu)")
            Text("Statut: \(jeu.statutJeu.rawValue)")
                .foregroundColor(jeu.statutJeu == .disponible ? .green : .red)

            Text("Date de dépôt: \(jeu.dateDepot, formatter: dateFormatter)")
            Text("Frais de dépôt: \(jeu.fraisDepot, specifier: "%.2f")€")
            Text("Remise sur dépôt: \(jeu.remiseDepot, specifier: "%.2f")%")

            Spacer()
            Button("Fermer") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

// 🔹 Formatter pour afficher correctement la date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
