//
//  SessionService.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation
import Combine

class SessionService: ObservableObject {
    @Published var isActive: Bool = false
    @Published var session: Session?

    private let apiUrl = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/session"

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


    func fetchAllSessions() -> AnyPublisher<[Session], Error> {
        guard let url = URL(string: apiUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Session].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func deleteSession(id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(apiUrl)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la suppression :", error)
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
        
    func addSession(_ session: Session, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: apiUrl) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601  // Utilisation du format ISO 8601 pour avoir le meme format des dates avec celles stockées dans le back

        do {
            let jsonData = try encoder.encode(session)
            request.httpBody = jsonData
        } catch {
            print("Erreur d'encodage JSON :", error)
            completion(false, "Erreur lors de l'encodage des données")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Erreur lors de l'ajout de la session :", error)
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
//                DispatchQueue.main.async {
//                    completion(true)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Réponse HTTP :", httpResponse)
//            }
//            if let data = data {
//                print("Réponse JSON :", String(data: data, encoding: .utf8) ?? "Aucune donnée")
//            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Aucune réponse du serveur")
                return
            }
            
            if httpResponse.statusCode == 201 {
                    completion(true, nil)
                } else if httpResponse.statusCode == 400, let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode([String: String].self, from: data)
                        completion(false, errorResponse["message"] ?? "Erreur inconnue")
                    } catch {
                        completion(false, "Erreur de format de réponse")
                    }
                } else {
                    completion(false, "Erreur serveur (\(httpResponse.statusCode))")
                }
        }.resume()
    }
}
