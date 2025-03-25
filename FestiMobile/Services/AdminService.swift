//
//  LoginRequest.swift
//  FestiMobile
//
//  Created by Zolan Givre on 22/03/2025.
//

import Foundation

class AdminService {
    

    //    Envoie une requête de connexion à l'API avec le nom d'utilisateur et le mot de passe. Si la connexion est réussie, elle enregistre un jeton d'authentification. Sinon, elle retourne un message d'erreur.
    //
    //    Entrées :
    //    - username (String)
    //    - password (String)
    //    - completion (Closure) : retourne un statut et un message.
    //
    //    Sorties :
    //    - Succès : Enregistre un jeton.
    //    - Échec : Retourne un message d'erreur.
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
            
            guard let response = response as? HTTPURLResponse else {
                completion(false, "Réponse invalide", nil)
                return
            }
            
            if response.statusCode != 200 {
                completion(false, "Erreur serveur (code \(response.statusCode))", nil)
                return
            }
            
            guard let data = data else {
                completion(false, "Aucune donnée reçue", nil)
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let message = json?["message"] as? String, message == "Connexion réussie" {
                    if let token = json?["token"] as? String {
                        UserDefaults.standard.set(token, forKey: "authToken")
                        completion(true, nil, nil)
                    } else {
                        completion(false, "Jeton manquant", nil)
                    }
                } else {
                    completion(false, "Utilisateur ou mot de passe incorrect", nil)
                }
            } catch {
                completion(false, "Erreur de parsing JSON", nil)
            }
        }.resume()
    }
}
