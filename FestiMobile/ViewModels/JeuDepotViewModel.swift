//
//  JeuDepotViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 15/03/2025.
//


import SwiftUI

class JeuDepotViewModel: ObservableObject {
    @Published var jeux: [JeuDepot] = []
    private let service = JeuDepotService()

    func fetchJeux() {
        service.fetchItems() { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }

    func filterItems(searchTerm: String, minPrice: Double?, maxPrice: Double?, availability: String) {
        service.filterItems(searchTerm: searchTerm, minPrice: minPrice, maxPrice: maxPrice, availability: availability) { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
}
