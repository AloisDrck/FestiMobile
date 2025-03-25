//
//  AchatView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct AchatView: View {
    @Binding var utilisateur: Utilisateur
    @StateObject private var venteViewModel = VenteViewModel()
    @StateObject private var jeuDepotViewModel = JeuDepotViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Jeux disponibles").font(.headline)) {
                        ForEach(jeuDepotViewModel.jeux) { item in
                            NavigationLink(destination: PanierView(utilisateur: $utilisateur, jeuDepot: item)) {
                                jeuDepotRow(item: item)
                            }
                        }
                    }
                    
                    if let errorMessage = venteViewModel.errorMessage {
                        Section {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
                .cornerRadius(15)
                .shadow(radius: 5)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .onAppear {
                    jeuDepotViewModel.fetchJeuxEnStock()
                }
            }
            .navigationTitle("Achat de jeux")
        }
        .background(
            Image("generalBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func jeuDepotRow(item: JeuDepot) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.nomJeu)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                
                Text("Éditeur : \(item.editeurJeu)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("\(item.prixJeu, specifier: "%.2f")€")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                
                Text("Stock : \(item.quantiteJeuDisponible)")
                    .font(.subheadline)
                    .foregroundColor(quantiteColor(for: item.quantiteJeuDisponible))
            }
        }
        .padding()
    }
}

// Fonction pour la couleur de la quantité
private func quantiteColor(for quantite: Int) -> Color {
    switch quantite {
    case 11...:
        return .green  // Beaucoup de stock
    case 1...10:
        return .orange // Stock faible
    default:
        return .red    // Rupture de stock
    }
}
