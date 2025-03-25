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
    
//    Récupérer tous les jeux.
//    Entrées :
//    - Aucun paramètre requis.
//    - completion : Met à jour la liste des jeux.
//
//    Sorties :
//    - Succès : La liste des jeux est mise à jour dans `jeux`.
//    - Échec : Aucune gestion d'erreur explicite ici, mais la liste des jeux sera mise à jour ou non selon le résultat.
    func fetchJeux() {
        service.fetchItems() { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
    
//    Récupérer les jeux en stock (quantité disponible > 0).
//    Entrées :
//    - Aucun paramètre requis.
//    - completion : Met à jour la liste des jeux en stock.
//
//    Sorties :
//    - Succès : La liste des jeux dont la quantité est supérieure à 0 est mise à jour dans `jeux`.
//    - Échec : Aucune gestion d'erreur explicite ici.
    func fetchJeuxEnStock() {
        service.fetchItems() { [weak self] jeux in
            DispatchQueue.main.async {
                // Filtrer les jeux où la quantiteDisponible est supérieure à 0
                let jeuxDisponibles = jeux.filter { $0.quantiteJeuDisponible > 0 }
                self?.jeux = jeuxDisponibles
            }
        }
    }
    
//    Filtrer les jeux.
//    Entrées :
//    - searchTerm (String) : Le terme de recherche pour filtrer les jeux.
//    - minPrice (Double ?) : Le prix minimum pour filtrer les jeux.
//    - maxPrice (Double ?) : Le prix maximum pour filtrer les jeux.
//    - availability (String) : Le filtre sur la disponibilité ("all", "available", "unavailable").
//    - completion : Met à jour la liste filtrée des jeux.
//
//    Sorties :
//    - Succès : La liste des jeux filtrée est mise à jour dans `jeux`.
//    - Échec : Aucune gestion d'erreur explicite ici.
    func filterItems(searchTerm: String, minPrice: Double?, maxPrice: Double?, availability: String) {
        service.filterItems(searchTerm: searchTerm, minPrice: minPrice, maxPrice: maxPrice, availability: availability) { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
    
//    Récupérer les jeux filtrés.
//    Entrées :
//    - searchTerm (String ?) : Le terme de recherche.
//    - minPrice (Double ?) : Le prix minimum pour filtrer.
//    - maxPrice (Double ?) : Le prix maximum pour filtrer.
//    - availabilityFilter (String ?) : Le filtre de disponibilité ("all", "available", "unavailable").
//
//    Sorties :
//    - Succès : La liste des jeux filtrée est mise à jour dans `jeux`.
//    - Échec : Aucune gestion d'erreur explicite ici.
    func fetchFilteredJeux(searchTerm: String?, minPrice: Double?, maxPrice: Double?, availabilityFilter: String?) {
        service.filterItems(searchTerm: searchTerm ?? "", minPrice: minPrice, maxPrice: maxPrice, availability: availabilityFilter ?? "all") { jeux in
            DispatchQueue.main.async {
                self.jeux = jeux
            }
        }
    }
    
//    Récupérer les jeux déposés par un utilisateur par ID.
//    Entrées :
//    - userId (String) : L'ID de l'utilisateur pour récupérer ses jeux déposés.
//    - completion : Met à jour la liste des jeux déposés de cet utilisateur.
//
//    Sorties :
//    - Succès : La liste des jeux déposés par l'utilisateur est mise à jour dans `jeux`.
//    - Échec : Aucune gestion d'erreur explicite ici.
    func fetchJeuxDepotByUserId(userId: String) {
        service.fetchJeuxDepotByUserId(userId: userId) { [weak self] jeux in
            DispatchQueue.main.async {
                self?.jeux = jeux
            }
        }
    }
    
//    Charger un jeu spécifique par ID.
//    Entrées :
//    - jeuId (String) : L'ID du jeu à charger.
//    - completion : Retourne le jeu via une closure.
//
//    Sorties :
//    - Succès : Le jeu est retourné et mis à jour dans `jeuDepot`.
//    - Échec : Un message d'erreur est retourné et `jeuDepot` reste `nil`.
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
    
//    Créer un nouveau jeu.
//    Entrées :
//    - jeuDepot (JeuDepot) : Le jeu à créer.
//    - completion : Retourne le résultat de la création (soit succès, soit erreur).
//
//    Sorties :
//    - Succès : Le jeu nouvellement créé est ajouté à la liste des jeux.
//    - Échec : Un message d'erreur est retourné.
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
    
//    Mettre à jour un jeu spécifique par ID.
//    Entrées :
//    - jeuId (String) : L'ID du jeu à mettre à jour.
//    - updates (Dictionary) : Le dictionnaire contenant les informations à mettre à jour.
//    - completion : Retourne le jeu mis à jour via une closure.
//
//    Sorties :
//    - Succès : Le jeu mis à jour est ajouté à la liste des jeux et mis à jour dans `jeuDepot`.
//    - Échec : Un message d'erreur est retourné.
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
    
//    Supprimer un jeu par ID.
//    Entrées :
//    - jeuId (String) : L'ID du jeu à supprimer.
//    - completion : Aucun, la suppression se fait directement dans la méthode.
//
//    Sorties :
//    - Succès : Le jeu est supprimé de la liste locale `jeux` si l'opération de suppression est réussie.
//    - Échec : Un message d'erreur est retourné et stocké dans `errorMessage` pour indiquer que la suppression a échoué.
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
