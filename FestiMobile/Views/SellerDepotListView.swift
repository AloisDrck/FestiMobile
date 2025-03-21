//
//  SellerDepotListView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct SellerDepotListView: View {
    @StateObject private var viewModel = JeuDepotViewModel()
    let userId: String

    @State private var selectedJeu: JeuDepot? // 🔹 Pour stocker le jeu sélectionné
    @State private var showPopup = false // 🔹 Contrôle l'affichage de la popup

    var body: some View {
        VStack {
            Text("Jeux déposés")
                .font(.title)
                .bold()
                .padding(.top)

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
            viewModel.fetchJeuxDepotByUserId(userId: userId)
        }
        .sheet(item: $selectedJeu) { jeu in
            JeuDepotDetailView(jeu: jeu) // 🔹 Affiche la popup avec les détails du jeu
        }
        .padding()
    }
}
