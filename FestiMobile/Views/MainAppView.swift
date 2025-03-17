//
//  MainAppView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = JeuDepotViewModel()
    @State private var searchTerm = ""
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    @State private var showFilters = false
    @State private var availabilityFilter = "all"

    var body: some View {
        NavigationView {
            VStack {
                // Barre de recherche
                TextField("Rechercher un jeu", text: $searchTerm, onEditingChanged: { _ in
                    viewModel.filterItems(searchTerm: searchTerm, minPrice: minPrice, maxPrice: maxPrice, availability: availabilityFilter)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Bouton pour afficher les filtres supplémentaires
                Button(action: {
                    showFilters.toggle()
                }) {
                    Text(showFilters ? "Masquer les filtres" : "+ de filtres")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Filtres avancés
                if showFilters {
                    VStack {
                        HStack {
                            Text("Prix min:")
                            TextField("Min", value: $minPrice, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)

                            Text("Prix max:")
                            TextField("Max", value: $maxPrice, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        .padding()

                        Picker("Disponibilité", selection: $availabilityFilter) {
                            Text("Tous").tag("all")
                            Text("Disponibles").tag("Disponible")
                            Text("Vendu").tag("Vendu")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        HStack {
                            Button("Appliquer") {
                                viewModel.filterItems(searchTerm: searchTerm, minPrice: minPrice, maxPrice: maxPrice, availability: availabilityFilter)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                            Button("Réinitialiser") {
                                searchTerm = ""
                                minPrice = nil
                                maxPrice = nil
                                availabilityFilter = "all"
                                viewModel.filterItems(searchTerm: "", minPrice: nil, maxPrice: nil, availability: "all")
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                // Liste des jeux
                List {
                    ForEach(viewModel.jeux) { item in
                        VStack(alignment: .leading) {
                            Text(item.nomJeu)
                                .font(.headline)
                            Text("Éditeur: \(item.editeurJeu)")
                                .font(.subheadline)
                            Text("Prix: \(item.prixJeu, specifier: "%.2f")€")
                                .font(.subheadline)
                            Text("Quantité: \(item.quantiteJeuDisponible)")
                                .font(.subheadline)
                            Text("Statut: \(item.statutJeu.rawValue)")
                                .font(.subheadline)
                            Text("Frais de dépôt: \(item.fraisDepot, specifier: "%.2f")€")
                                .font(.subheadline)
                            Text("Remise: \(item.remiseDepot)%")
                                .font(.subheadline)
                        }
                        .padding()
                    }
                }
                .onAppear {
                    viewModel.fetchJeux()
                }
            }
            .navigationTitle("Liste des jeux")
        }
    }
}
