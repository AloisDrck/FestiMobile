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

    // Récupérer les jeux vendus par l'ID de la vente.
    // Entrées :
    // - idVente (String) : L'ID de la vente pour laquelle on souhaite récupérer les jeux vendus.
    // - Aucun retour explicite, mais la liste `jeuxVendus` est mise à jour si la récupération réussit.
    //
    // Sorties :
    // - Succès : La liste `jeuxVendus` est mise à jour avec les jeux vendus récupérés.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit. Si une erreur survient, le message d'erreur contient la description de l'erreur.

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
