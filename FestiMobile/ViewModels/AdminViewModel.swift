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
    
    func logout() {
        self.isLoggedIn = false
        self.savedUsername = ""
        self.username = ""
    }
}
