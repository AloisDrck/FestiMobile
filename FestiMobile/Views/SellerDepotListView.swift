//
//  SellerDepotListView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct SellerDepotListView: View {
    @StateObject private var viewModel = JeuDepotViewModel()
    @Binding var utilisateur: Utilisateur

    @State private var selectedJeu: JeuDepot?
    @State private var showPopup = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.jeux.isEmpty {
                    Text("Aucun jeu déposé.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.jeux, id: \.id) { jeu in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(jeu.nomJeu)
                                    .font(.headline)
                                Text("Prix: \(jeu.prixJeu, specifier: "%.2f")€")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(jeu.statutJeu.rawValue)
                                .foregroundColor(jeu.statutJeu == .disponible ? .green : .red)
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            selectedJeu = jeu
                            showPopup = true
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchJeuxDepotByUserId(userId: utilisateur.id)
            }
            .sheet(item: $selectedJeu) { jeu in
                JeuDepotDetailView(jeu: jeu)
            }
            .padding()
            .navigationTitle("Liste des jeux déposés")
        }
        .navigationTitle("\(utilisateur.nom) \(utilisateur.prenom)")
    }
}
