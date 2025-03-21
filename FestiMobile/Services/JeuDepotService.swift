//
//  JeuDepotService.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 13/03/2025.
//


import Foundation

class JeuDepotService: ObservableObject {
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/jeuDepot"

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
    
    func fetchJeuxDepotByUserId(userId: String, completion: @escaping ([JeuDepot]) -> Void) {
        guard let url = URL(string: "https://festivawin-back-16b79a35ef75.herokuapp.com/api/jeuDepot/user/\(userId)") else { return }

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

}
