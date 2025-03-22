//
//  TableView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct TableView: View {
    var ventes: [Vente]
    var role: RoleUtilisateur // "vendeur" ou "acheteur"
    @Binding var showDetailView: Bool
    @Binding var selectedVente: Vente?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    Text(role == .vendeur ? "Acheteur" : "Vendeur")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    Text("Montant (€)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                
                ForEach(ventes) { vente in
                    Button(action: {
                        selectedVente = vente
                        showDetailView.toggle() // Affiche le popup
                    }) {
                        HStack {
                            Text(formattedDate(vente.dateVente))
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            
                            let nomPrenom = role == .vendeur ?
                            "\(vente.acheteurNom ?? "Nom Inconnu") \(vente.acheteurPrenom ?? "")" :
                            "\(vente.vendeurNom ?? "Nom Inconnu") \(vente.vendeurPrenom ?? "")"
                            
                            Text(nomPrenom)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                            
                            Text(String(format: "%.2f", vente.montantTotal))
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .scaleEffect(1.0)
                    }
                }
            }
        }
        .padding()
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
