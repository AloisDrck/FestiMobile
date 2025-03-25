//
//  TableView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct TableView: View {
    var ventes: [Vente]
    var role: RoleUtilisateur
    @Binding var showDetailView: Bool
    @Binding var selectedVente: Vente?
    
    var body: some View {
        VStack {
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
            .shadow(radius: 20)
            .background(Color(red: 61/255, green: 72/255, blue: 106/255))
            .cornerRadius(15)
            List {
                // Liste des ventes
                ForEach(ventes) { vente in
                    Button(action: {
                        selectedVente = vente
                        showDetailView.toggle()
                    }) {
                        HStack {
                            Text(formattedDate(vente.dateVente))
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                            
                            let nomPrenom = role == .vendeur ?
                            "\(vente.acheteurNom ?? "Nom Inconnu") \(vente.acheteurPrenom ?? "")" :
                            "\(vente.vendeurNom ?? "Nom Inconnu") \(vente.vendeurPrenom ?? "")"
                            
                            Text(nomPrenom)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                            
                            Text(String(format: "%.2f", vente.montantTotal))
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .cornerRadius(15)
            .shadow(radius: 5)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .padding()
        
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
