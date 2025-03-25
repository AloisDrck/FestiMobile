//
//  UtilisateurViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

class UtilisateurViewModel: ObservableObject {
    @Published var utilisateurs: [Utilisateur] = []
    @Published var vendeurs: [Utilisateur] = []
    @Published var acheteurs: [Utilisateur] = []
    @Published var errorMessage: String?
    
    private let service = UtilisateurService()
    
    // Récupérer tous les utilisateurs.
    // Entrées :
    // - Aucun argument.
    // - Les utilisateurs récupérés sont stockés dans `utilisateurs` via un appel au service.
    //
    // Sorties :
    // - Succès : La liste des utilisateurs est mise à jour avec les utilisateurs récupérés.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit.

    func fetchAllUsers() {
        service.getAllUsers { users, error in
            DispatchQueue.main.async {
                if let users = users {
                    self.utilisateurs = users
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Récupérer tous les vendeurs.
    // Entrées :
    // - Aucun argument.
    // - Les vendeurs récupérés sont stockés dans `vendeurs` via un appel au service.
    //
    // Sorties :
    // - Succès : La liste des vendeurs est mise à jour avec les vendeurs récupérés.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit.

    func fetchSellers() {
        service.getAllSellers { sellers, error in
            DispatchQueue.main.async {
                if let sellers = sellers {
                    self.vendeurs = sellers
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Récupérer tous les acheteurs.
    // Entrées :
    // - Aucun argument.
    // - Les acheteurs récupérés sont stockés dans `acheteurs` via un appel au service.
    //
    // Sorties :
    // - Succès : La liste des acheteurs est mise à jour avec les acheteurs récupérés.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit.

    func fetchBuyers() {
        service.getAllBuyers { buyers, error in
            DispatchQueue.main.async {
                if let buyers = buyers {
                    self.acheteurs = buyers
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Créer un nouvel utilisateur et l'ajouter à la liste locale.
    // Entrées :
    // - utilisateur (Utilisateur) : L'objet `Utilisateur` à créer.
    // - Aucun retour explicite, mais la liste `utilisateurs` est mise à jour si la création réussit.
    //
    // Sorties :
    // - Succès : L'utilisateur est ajouté à la liste `utilisateurs`.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit.

    func createUser(_ utilisateur: Utilisateur) {
        service.createUser(utilisateur: utilisateur) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.utilisateurs.append(utilisateur)
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Mettre à jour un utilisateur existant.
    // Entrées :
    // - utilisateur (Utilisateur) : L'objet `Utilisateur` à mettre à jour avec ses nouvelles données.
    // - Aucun retour explicite, mais l'utilisateur est mis à jour dans la liste locale si la mise à jour réussit.
    //
    // Sorties :
    // - Succès : L'utilisateur dans la liste `utilisateurs` est mis à jour.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit. Si l'ID est manquant, un message d'erreur est renvoyé.

    func updateUser(_ utilisateur: Utilisateur) {
        guard let userId = utilisateur.id else {
            // Si l'ID est nul, retourne ou affiche un message d'erreur
            self.errorMessage = "ID utilisateur manquant"
            return
        }
        service.updateUser(id: userId, utilisateur: utilisateur) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Met à jour l'utilisateur dans la liste
                    if let index = self.utilisateurs.firstIndex(where: { $0.id == utilisateur.id }) {
                        self.utilisateurs[index] = utilisateur
                    }
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Supprimer un utilisateur par son ID.
    // Entrées :
    // - id (String) : L'ID de l'utilisateur à supprimer.
    // - completion (Bool, Error?) : Closure retournée avec le résultat de la suppression (succès ou échec) et l'erreur le cas échéant.
    //
    // Sorties :
    // - Succès : L'utilisateur est supprimé de la liste `utilisateurs`.
    // - Échec : La suppression échoue et un message d'erreur est renvoyé via le paramètre `completion`.

    func deleteUser(id: String, completion: @escaping (Bool, Error?) -> Void) {
        service.deleteUser(id: id) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.utilisateurs.removeAll { $0.id == id }
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }
    }
    
    // Récupérer un utilisateur spécifique par son ID.
    // Entrées :
    // - id (String) : L'ID de l'utilisateur à récupérer.
    // - completion (Utilisateur?, Error?) : Closure retournée avec l'utilisateur récupéré ou une erreur.
    //
    // Sorties :
    // - Succès : L'utilisateur correspondant à l'ID est renvoyé dans la closure `completion`.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` et l'erreur est renvoyée dans la closure `completion` si une erreur se produit.

    func getUserById(id: String, completion: @escaping (Utilisateur?, Error?) -> Void) {
        service.getUserById(id: id) { utilisateur, error in
            DispatchQueue.main.async {
                if let utilisateur = utilisateur {
                    completion(utilisateur, nil)
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(nil, error)
                }
            }
        }
    }
}
