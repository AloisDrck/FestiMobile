//
//  BilanViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

class BilanViewModel: ObservableObject {
    
    private var bilans: [Bilan] = []
    
//    Récupérer tous les bilans.
//    Entrées :
//    - completion (Closure) : Retourne un tableau de bilans en cas de succès ou une erreur en cas d'échec.
//
//    Sorties :
//    - Succès : La liste des bilans est retournée à la vue.
//    - Échec : Un message d'erreur est retourné en cas de problème avec la récupération des bilans.
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
    
//    Récupérer un bilan spécifique par ID du vendeur.
//    Entrées :
//    - vendeurId (String) : L'ID du vendeur pour lequel on souhaite récupérer le bilan.
//    - completion (Closure) : Retourne le bilan correspondant en cas de succès ou une erreur en cas d'échec.
//
//    Sorties :
//    - Succès : Le bilan du vendeur est retourné.
//    - Échec : Un message d'erreur est retourné si le bilan n'est pas trouvé ou si une erreur survient.
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
    
//    Mettre à jour un bilan.
//    Entrées :
//    - id (String) : L'ID du bilan à mettre à jour.
//    - vendeurId (String) : L'ID du vendeur concerné.
//    - sommeDues (Double), totalFrais (Double), totalCommissions (Double), gains (Double) : Les informations à mettre à jour dans le bilan.
//    - completion (Closure) : Retourne un message de succès ou une erreur après la mise à jour.
//
//    Sorties :
//    - Succès : Un message indiquant que la mise à jour a été effectuée avec succès.
//    - Échec : Un message d'erreur si la mise à jour échoue.
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
    
//    Supprimer un bilan.
//    Entrées :
//    - id (String) : L'ID du bilan à supprimer.
//    - completion (Closure) : Retourne un message de succès ou une erreur après la suppression.
//
//    Sorties :
//    - Succès : Un message confirmant que le bilan a été supprimé avec succès.
//    - Échec : Un message d'erreur si la suppression échoue.
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
}
