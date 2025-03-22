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
    @Published var userRole: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private let adminService = AdminService()

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    func login(completion: @escaping (Bool) -> Void) {
        adminService.login(username: username, password: password) { success, message, role in
            DispatchQueue.main.async {
                if success, let role = role {
                    self.userRole = role
                    self.isLoggedIn = true
                    completion(true)
                } else {
                    self.errorMessage = message ?? "Erreur inconnue"
                    completion(false)
                }
            }
        }
    }
    
    func checkUserStatus() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }

    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userRole")
    }

    func getUserRole() -> String {
        return UserDefaults.standard.string(forKey: "userRole") ?? "Inconnu"
    }
}
