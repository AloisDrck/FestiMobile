//
//  UtilisateurService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

class UtilisateurService {
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/utilisateur"
    
    // Récupérer tous les utilisateurs
    func getAllUsers(completion: @escaping ([Utilisateur]?, Error?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let utilisateurs = try JSONDecoder().decode([Utilisateur].self, from: data)
                completion(utilisateurs, nil)
            } catch let decodeError {
                completion(nil, NSError(domain: "Decoding Error", code: 1, userInfo: [NSLocalizedDescriptionKey: decodeError.localizedDescription]))
            }
        }.resume()
    }

    // Récupérer tous les vendeurs
    func getAllSellers(completion: @escaping ([Utilisateur]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/vendeurs") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0))
                return
            }
            
            do {
                let sellers = try JSONDecoder().decode([Utilisateur].self, from: data)
                completion(sellers, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }


    
    // Récupérer tous les acheteurs
    func getAllBuyers(completion: @escaping ([Utilisateur]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/acheteurs") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0))
                return
            }
            
            do {
                let buyers = try JSONDecoder().decode([Utilisateur].self, from: data)
                completion(buyers, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // Récupérer un utilisateur par ID
    func getUserById(id: String, completion: @escaping (Utilisateur?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0))
                return
            }
            
            do {
                let utilisateur = try JSONDecoder().decode(Utilisateur.self, from: data)
                completion(utilisateur, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // Créer un nouvel utilisateur
    func createUser(utilisateur: Utilisateur, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(utilisateur)
        } catch {
            completion(false, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }.resume()
    }
    
    // Mettre à jour un utilisateur
    func updateUser(id: String, utilisateur: Utilisateur, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(utilisateur)
        } catch {
            completion(false, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }.resume()
    }
    
    // Supprimer un utilisateur
    func deleteUser(id: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }.resume()
    }
}
