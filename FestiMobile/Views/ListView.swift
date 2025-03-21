//
//  ListView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 18/03/2025.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = VenteViewModel()
    @Binding var utilisateur: Utilisateur
    @State private var showDetailView = false
    @State private var selectedVente: Vente? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if viewModel.ventes.isEmpty {
                    Text("Aucune vente trouvée.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    TableView(ventes: viewModel.ventes, role: utilisateur.role, showDetailView: $showDetailView, selectedVente: $selectedVente)
                }
            }
            .onAppear {
                viewModel.fetchVentes(id: utilisateur.id, role: utilisateur.role)
            }
            .navigationTitle(utilisateur.role == .vendeur ? "Liste des ventes" : "Liste des achats")
            .sheet(isPresented: $showDetailView) {
                if let vente = selectedVente {
                    ListDetailView(vente: vente, utilisateur: $utilisateur)
                }
            }
        }
        .navigationTitle("\(utilisateur.nom) \(utilisateur.prenom)")
    }
}

struct TableView: View {
    var ventes: [Vente]
    var role: RoleUtilisateur // "vendeur" ou "acheteur"
    @Binding var showDetailView: Bool
    @Binding var selectedVente: Vente?
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Date")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text(role == .vendeur ? "Acheteur" : "Vendeur")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                    Text("Montant (€)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                
                ForEach(ventes) { vente in
                    Button(action: {
                        selectedVente = vente
                        showDetailView.toggle() // Affiche le popup
                    }) {
                        HStack {
                            Text(formattedDate(vente.dateVente))
                                .frame(maxWidth: .infinity)
                            
                            // Affichage conditionnel en fonction du rôle
                            let nomPrenom = role == .vendeur ?
                            "\(vente.acheteurNom ?? "Nom Inconnu") \(vente.acheteurPrenom ?? "")" :
                            "\(vente.vendeurNom ?? "Nom Inconnu") \(vente.vendeurPrenom ?? "")"
                            
                            Text(nomPrenom)
                                .frame(maxWidth: .infinity)
                            
                            Text(String(format: "%.2f", vente.montantTotal))
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
