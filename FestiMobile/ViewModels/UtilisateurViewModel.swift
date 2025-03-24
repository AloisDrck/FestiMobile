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
}
