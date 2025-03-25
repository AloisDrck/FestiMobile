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
    @State private var navigateToLogin: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // Barre de recherche
                    TextField("Rechercher un jeu", text: $searchTerm, onEditingChanged: { _ in
                        viewModel.filterItems(searchTerm: searchTerm, minPrice: minPrice, maxPrice: maxPrice, availability: availabilityFilter)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    // Bouton pour afficher les filtres supplémentaires à droite
                    Button(action: {
                        showFilters.toggle()
                    }) {
                        Image(systemName: showFilters ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                            .resizable()
                            .frame(width: 24, height: 24) // Taille de l'icône
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                
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
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            
                            Button("Réinitialiser") {
                                searchTerm = ""
                                minPrice = nil
                                maxPrice = nil
                                availabilityFilter = "all"
                                viewModel.filterItems(searchTerm: "", minPrice: nil, maxPrice: nil, availability: "all")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 20)                }
                
                List {
                    ForEach(viewModel.jeux) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.nomJeu)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                Text("Éditeur: \(item.editeurJeu)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(item.prixJeu, specifier: "%.2f")€")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                Text("Quantité: \(item.quantiteJeuDisponible)")
                                    .font(.subheadline)
                                    .foregroundColor(quantiteColor(for: item.quantiteJeuDisponible))
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                .cornerRadius(15)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .onAppear {
                    viewModel.fetchJeux()
                }
            }
        }
        .navigationTitle("Liste des jeux")
        .background(
            Image("generalBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}

private func quantiteColor(for quantite: Int) -> Color {
    if quantite > 10 {
        return .green
    } else if quantite >= 1 {
        return .orange
    } else {
        return .red
    }
}
