//
//  BilanViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

// ViewModel pour interagir avec le BilanService et fournir des données formatées à la vue
class BilanViewModel: ObservableObject {
    
    private var bilans: [Bilan] = []
    
    // Récupérer tous les bilans
    func getBilans(completion: @escaping (Result<[Bilan], Error>) -> Void) {
        BilanService.shared.getBilans { [weak self] result in
            switch result {
            case .success(let bilans):
                self?.bilans = bilans
                completion(.success(bilans))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Récupérer un bilan spécifique par ID du vendeur
    func getBilanById(vendeurId: String, completion: @escaping (Result<Bilan, Error>) -> Void) {
        BilanService.shared.getBilanById(vendeurId: vendeurId) { result in
            switch result {
            case .success(let bilan):
                completion(.success(bilan))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Mettre à jour un bilan
    func updateBilan(id: String, vendeurId: String, sommeDues: Double, totalFrais: Double, totalCommissions: Double, gains: Double, completion: @escaping (Result<String, Error>) -> Void) {
        BilanService.shared.updateBilan(id: id, vendeurId: vendeurId, sommeDues: sommeDues, totalFrais: totalFrais, totalCommissions: totalCommissions, gains: gains) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Supprimer un bilan
    func deleteBilan(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        BilanService.shared.deleteBilan(id: id) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Accéder à la liste des bilans
    func getBilansList() -> [Bilan] {
        return bilans
    }
}
