//
//  UtilisateurService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

class UtilisateurService {
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/utilisateur"
    
//    Récupérer tous les utilisateurs.
//    Entrées :
//    - Aucune entrée.
//
//    Sorties :
//    - Succès : Retourne un tableau d'utilisateurs (`[Utilisateur]`).
//    - Échec : Retourne une erreur (`Error`).

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

//    Récupérer tous les vendeurs.
//    Entrées :
//    - Aucune entrée.
//
//    Sorties :
//    - Succès : Retourne un tableau de vendeurs (`[Utilisateur]`).
//    - Échec : Retourne une erreur (`Error`).

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

//    Récupérer tous les acheteurs.
//    Entrées :
//    - Aucune entrée.
//
//    Sorties :
//    - Succès : Retourne un tableau d'acheteurs (`[Utilisateur]`).
//    - Échec : Retourne une erreur (`Error`).

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
    
//    Récupérer un utilisateur par ID.
//    Entrées :
//    - id (String) : ID de l'utilisateur à récupérer.
//    - completion (Closure) : Retourne l'utilisateur récupéré ou `nil` en cas d'erreur.
//
//    Sorties :
//    - Succès : Retourne l'utilisateur correspondant à l'ID.
//    - Échec : Retourne une erreur (`Error`).

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
    
//    Créer un nouvel utilisateur.
//   Entrées :
//   - utilisateur (Utilisateur) : L'utilisateur à créer.
//   - completion (Closure) : Retourne un succès (true) ou une erreur (false) avec un message d'erreur si applicable.
//
//   Sorties :
//   - Succès : Retourne `true`.
//   - Échec : Retourne `false` avec un message d'erreur.

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
    
//    Mettre à jour un utilisateur.
//    Entrées :
//    - id (String) : ID de l'utilisateur à mettre à jour.
//    - utilisateur (Utilisateur) : L'utilisateur avec les nouvelles données.
//    - completion (Closure) : Retourne un succès (true) ou une erreur (false) avec un message d'erreur si applicable.
//
//    Sorties :
//    - Succès : Retourne `true`.
//    - Échec : Retourne `false` avec un message d'erreur.

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
    
//    Supprimer un utilisateur.
//    Entrées :
//    - id (String) : ID de l'utilisateur à supprimer.
//    - completion (Closure) : Retourne un succès (true) ou une erreur (false) avec un message d'erreur si applicable.
//
//    Sorties :
//    - Succès : Retourne `true`.
//    - Échec : Retourne `false` avec un message d'erreur.
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
