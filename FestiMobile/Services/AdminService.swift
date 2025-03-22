//
//  LoginRequest.swift
//  FestiMobile
//
//  Created by Zolan Givre on 22/03/2025.
//

import Foundation
import JWTDecode

class AdminService {
    func login(username: String, password: String, completion: @escaping (Bool, String?, String?) -> Void) {
        guard let url = URL(string: "https://festivawin-back-16b79a35ef75.herokuapp.com/api/admin/login") else {
            completion(false, "URL invalide", nil)
            return
        }
        
        let body: [String: String] = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Erreur réseau : \(error.localizedDescription)", nil)
                return
            }
            
            guard let data = data else {
                completion(false, "Aucune donnée reçue", nil)
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Données reçues : \(dataString)")  // Affiche les données brutes
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                print("Réponse JSON : \(json ?? [:])")
                
                if let message = json?["message"] as? String, message == "Connexion réussie" {
                    // Récupérer le jeton d'authentification
                    if let token = json?["token"] as? String {
                        // Décoder le token pour récupérer le statut
                        do {
                            let jwt = try JWTDecode.decode(jwt: token)
                            if let role = jwt.body["statut"] as? String {
                                // Stocker le jeton et le rôle dans UserDefaults
                                UserDefaults.standard.set(token, forKey: "authToken")
                                UserDefaults.standard.set(role, forKey: "userStatus")
                                completion(true, nil, role)
                            } else {
                                completion(false, "Statut manquant dans le token", nil)
                            }
                        } catch {
                            completion(false, "Erreur de décodage du token", nil)
                        }
                    } else {
                        completion(false, "Jeton manquant", nil)
                    }
                } else {
                    completion(false, "Utilisateur ou mot de passe incorrect", nil)
                }
            } catch {
                completion(false, "Erreur de parsing JSON", nil)
            }
        }
    }
}
  
