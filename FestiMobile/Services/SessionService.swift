//
//  SessionService.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//


import Foundation

class SessionService: ObservableObject {
    @Published var isActive: Bool = false
    @Published var session: Session?

    private let apiUrl = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/session" // Faut que tu mette ton adresse IP au lieux de la mienne avant le port

    func fetchSessionStatus() {
        guard let url = URL(string: "\(apiUrl)/activesession") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let response = try JSONDecoder().decode([String: Bool].self, from: data)
                DispatchQueue.main.async {
                    self.isActive = response["isActive"] ?? false
                    self.fetchSessionDetails()
                }
            } catch {
                print("Erreur lors de la récupération du statut de la session :", error)
            }
        }.resume()
    }

    func fetchSessionDetails() {
        let sessionUrl = isActive ? "\(apiUrl)/encours" : "\(apiUrl)/nextsession"
        
        guard let url = URL(string: sessionUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let session = try JSONDecoder().decode(Session.self, from: data)
                DispatchQueue.main.async {
                    self.session = session
                }
            } catch {
                print("Erreur lors de la récupération de la session :", error)
            }
        }.resume()
    }
}
