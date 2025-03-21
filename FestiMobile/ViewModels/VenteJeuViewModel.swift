//
//  VenteJeuViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 19/03/2025.
//

import SwiftUI

class VenteJeuViewModel: ObservableObject {
    @Published var jeuxVendus: [VenteJeu] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = VenteJeuService()

    func fetchJeuxVendus(idVente: String) {
        isLoading = true
        errorMessage = nil

        service.getJeuxVendusByVenteId(idVente: idVente) { [weak self] (result: Result<[VenteJeu], Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let jeux):
                    self?.jeuxVendus = jeux
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
}
