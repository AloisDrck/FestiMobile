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
        NavigationStack {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding()
                }
                
                if viewModel.ventes.isEmpty {
                    Text("Aucune vente trouvée.")
                        .foregroundColor(.gray)
                        .font(.title3)
                        .padding()
                } else {
                    TableView(ventes: viewModel.ventes, role: utilisateur.role, showDetailView: $showDetailView, selectedVente: $selectedVente)
                        .padding(.top, 10)
                }
            }
            .onAppear {
                guard let utilisateurId = utilisateur.id else { return }
                viewModel.fetchVentes(id: utilisateurId, role: utilisateur.role)
            }
            .navigationTitle(utilisateur.role == .vendeur ? "Liste des ventes" : "Liste des achats")
            .sheet(isPresented: $showDetailView) {
                if let vente = selectedVente {
                    ListDetailView(vente: vente, utilisateur: $utilisateur)
                }
            }
            .background(
                Image("generalBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationTitle("\(utilisateur.nom) \(utilisateur.prenom)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
