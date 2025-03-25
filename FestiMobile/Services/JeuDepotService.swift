//
//  JeuDepotService.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 13/03/2025.
//


import Foundation

class JeuDepotService: ObservableObject {
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/jeuDepot"

//    Récupère tous les objets `JeuDepot` depuis l'API et retourne une liste des jeux ou une erreur en cas d'échec.
//
//    Entrées :
//    - completion (Closure) : retourne une liste d'objets `JeuDepot`.
//
//    Sorties :
//    - Succès : Liste des objets `JeuDepot`.
//    - Échec : Retourne une erreur.
    func fetchItems(completion: @escaping ([JeuDepot]) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    
                    let decodedData = try JSONDecoder().decode([JeuDepot].self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                } catch {
                    print("Erreur de décodage :", error)
                }
            }
        }.resume()
    }
    
//    Filtre les objets `JeuDepot` selon les critères spécifiés : terme de recherche, prix minimum, prix maximum et disponibilité.
//
//    Entrées :
//    - searchTerm (String) : Terme de recherche à appliquer sur les jeux.
//    - minPrice (Double?) : Prix minimum des jeux.
//    - maxPrice (Double?) : Prix maximum des jeux.
//    - availability (String) : Filtre sur la disponibilité des jeux (Disponible / Vendu).
//    - completion (Closure) : retourne la liste filtrée des jeux ou une erreur.
//
//    Sorties :
//    - Succès : Liste des objets `JeuDepot` filtrés.
//    - Échec : Retourne une erreur.
    func filterItems(searchTerm: String, minPrice: Double?, maxPrice: Double?, availability: String, completion: @escaping ([JeuDepot]) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/filter")
        
        var queryItems: [URLQueryItem] = []
        if !searchTerm.isEmpty {
            queryItems.append(URLQueryItem(name: "searchTerm", value: searchTerm))
        }
        if let minPrice = minPrice {
            queryItems.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
        }
        if let maxPrice = maxPrice {
            queryItems.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
        }
        if availability != "all" {
            queryItems.append(URLQueryItem(name: "availabilityFilter", value: availability == "Disponible" ? "Disponible" : "Vendu"))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let decodedData = try JSONDecoder().decode([JeuDepot].self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                } catch {
                    print("Erreur de décodage 2 :", error)
                }
            }
        }.resume()
    }
    
//    Récupère les objets `JeuDepot` associés à un utilisateur spécifique.
//
//    Entrées :
//    - userId (String) : ID de l'utilisateur pour lequel on récupère les jeux déposés.
//    - completion (Closure) : retourne la liste des jeux déposés ou une erreur.
//
//    Sorties :
//    - Succès : Liste des objets `JeuDepot` de l'utilisateur.
//    - Échec : Retourne une erreur.
    func fetchJeuxDepotByUserId(userId: String, completion: @escaping ([JeuDepot]) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/\(userId)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Erreur de requête:", error?.localizedDescription ?? "Erreur inconnue")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([JeuDepot].self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print("Erreur de décodage JSON:", error)
            }
        }.resume()
    }
    
//    Récupère un objet `JeuDepot` spécifique en fonction de son ID.
//
//    Entrées :
//    - jeuId (String) : ID du jeu à récupérer.
//    - completion (Closure) : retourne l'objet `JeuDepot` ou une erreur.
//
//    Sorties :
//    - Succès : Objet `JeuDepot`.
//    - Échec : Retourne une erreur.
    func fetchJeuDepotById(jeuId: String, completion: @escaping (Result<JeuDepot, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(jeuId)") else {
            completion(.failure(NSError(domain: "URL invalide", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données manquantes", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(JeuDepot.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
//    Crée un nouveau jeu dépôt avec les données fournies et retourne l'objet créé ou une erreur.
//
//    Entrées :
//    - jeuDepot (JeuDepot) : Données du jeu à créer.
//    - completion (Closure) : retourne l'objet `JeuDepot` créé ou une erreur.
//
//    Sorties :
//    - Succès : Objet `JeuDepot` créé.
//    - Échec : Retourne une erreur.
    func createJeuDepot(jeuDepot: JeuDepot, completion: @escaping (Result<JeuDepot, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)") else {
            completion(.failure(NSError(domain: "URL invalide", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(jeuDepot)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données manquantes", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(JeuDepot.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

//    Met à jour un jeu dépôt existant en fonction des mises à jour fournies.
//
//    Entrées :
//    - jeuId (String) : ID du jeu dépôt à mettre à jour.
//    - updates (Dictionnaire [String: Any]) : Mises à jour des propriétés du jeu.
//    - completion (Closure) : retourne l'objet mis à jour ou une erreur.
//
//    Sorties :
//    - Succès : Objet `JeuDepot` mis à jour.
//    - Échec : Retourne une erreur.
    func updateJeuDepot(jeuId: String, updates: [String: Any], completion: @escaping (Result<JeuDepot, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(jeuId)") else {
            completion(.failure(NSError(domain: "URL invalide", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updates, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données manquantes", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(JeuDepot.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

//    Supprime un jeu dépôt en fonction de son ID et retourne un succès ou une erreur.
//
//    Entrées :
//    - jeuId (String) : ID du jeu dépôt à supprimer.
//    - completion (Closure) : retourne un message de succès ou une erreur.
//
//    Sorties :
//    - Succès : Aucun retour (vide).
//    - Échec : Retourne une erreur.
    func deleteJeuDepot(jeuId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(jeuId)") else {
            completion(.failure(NSError(domain: "URL invalide", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        }.resume()
    }
}
