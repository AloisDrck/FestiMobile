//
//  AdminViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 22/03/2025.
//

import SwiftUI

class AdminViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private let adminService = AdminService()

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("savedUsername") public var savedUsername: String = ""

    init() {
        if !savedUsername.isEmpty {
            self.username = savedUsername
            self.isAuthenticated = true
        }
    }
    
//    Connexion de d'un administrateur ou d'un gestionnaire.
//    Entrées :
//    - completion (Closure) : Retourne un Booléen (`true` si la connexion est réussie, sinon `false`) et met à jour l'état d'authentification de l'utilisateur.
//
//    Sorties :
//    - Succès : L'utilisateur est connecté avec succès, l'état `isLoggedIn` est mis à `true` et le nom d'utilisateur est enregistré dans `savedUsername`.
//    - Échec : L'état d'authentification échoue et un message d'erreur est affiché. Le message d'erreur peut être personnalisé ou par défaut `"Erreur inconnue"`.
    func login(completion: @escaping (Bool) -> Void) {
        adminService.login(username: username, password: password) { success, message, user in
            DispatchQueue.main.async {
                if success {
                    self.isLoggedIn = true
                    self.savedUsername = self.username
                    completion(true)
                } else {
                    self.errorMessage = message ?? "Erreur inconnue"
                    completion(false)
                }
            }
        }
    }
    
//    Déconnexion de l'administrateur.
//    Entrées :
//    - Aucun paramètre requis.
//
//    Sorties :
//    - L'utilisateur est déconnecté, l'état `isLoggedIn` est mis à `false`, et les informations d'identification (nom d'utilisateur et mot de passe) sont effacées.
    func logout() {
        self.isLoggedIn = false
        self.savedUsername = ""
        self.username = ""
    }
}
