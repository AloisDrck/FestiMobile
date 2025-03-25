//
//  JeuDepotViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 15/03/2025.
//

import SwiftUI

class JeuDepotViewModel: ObservableObject {
    @Published var jeux: [JeuDepot] = []
    @Published var jeuDepot: JeuDepot?
    @Published var errorMessage: String?
    private let service = JeuDepotService()
    
    func fetchJeux() {
        service.fetchItems() { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
    
    func fetchJeuxEnStock() {
        service.fetchItems() { [weak self] jeux in
            DispatchQueue.main.async {
                // Filtrer les jeux où la quantiteDisponible est supérieure à 0
                let jeuxDisponibles = jeux.filter { $0.quantiteJeuDisponible > 0 }
                self?.jeux = jeuxDisponibles
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
    
    func fetchFilteredJeux(searchTerm: String?, minPrice: Double?, maxPrice: Double?, availabilityFilter: String?) {
        service.filterItems(searchTerm: searchTerm ?? "", minPrice: minPrice, maxPrice: maxPrice, availability: availabilityFilter ?? "all") { jeux in
            DispatchQueue.main.async {
                self.jeux = jeux
            }
        }
    }
    
    func fetchJeuxDepotByUserId(userId: String) {
        service.fetchJeuxDepotByUserId(userId: userId) { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
    
    func loadJeuDepotById(jeuId: String, completion: @escaping (JeuDepot?) -> Void) {
        service.fetchJeuDepotById(jeuId: jeuId) { result in
            switch result {
            case .success(let jeu):
                DispatchQueue.main.async {
                    self.jeuDepot = jeu
                    completion(jeu) // Retourne le jeu via la closure
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                    completion(nil) // En cas d'erreur, on passe `nil`
                }
            }
        }
    }
    
    func createJeuDepot(jeuDepot: JeuDepot, completion: @escaping (Result<JeuDepot, Error>) -> Void) {
        service.createJeuDepot(jeuDepot: jeuDepot) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newJeuDepot):
                    self?.jeux.append(newJeuDepot)  // Mets à jour la liste de jeux si c'est nécessaire
                    completion(.success(newJeuDepot))  // Renvoie le résultat via la closure
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la création: \(error.localizedDescription)"
                    completion(.failure(error))  // Renvoie l'erreur via la closure
                }
            }
        }
    }
    
    func updateJeuDepot(jeuId: String, updates: [String: Any], completion: @escaping (Result<JeuDepot, Error>) -> Void) {
        service.updateJeuDepot(jeuId: jeuId, updates: updates) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedJeu):
                    if let index = self?.jeux.firstIndex(where: { $0.id == jeuId }) {
                        self?.jeux[index] = updatedJeu  // Met à jour la liste locale
                    }
                    self?.jeuDepot = updatedJeu  // Met à jour le jeu actuel
                    completion(.success(updatedJeu))
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la mise à jour : \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteJeuDepot(jeuId: String) {
        service.deleteJeuDepot(jeuId: jeuId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.jeux.removeAll { $0.id == jeuId }
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la suppression: \(error.localizedDescription)"
                }
            }
        }
    }
}
