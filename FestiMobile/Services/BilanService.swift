//
//  BilanService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import Foundation

class BilanService {
    
    static let shared = BilanService()
    
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/bilan"
    
    private init() {}
    
    // Récupérer tous les bilans
    func getBilans(completion: @escaping (Result<[Bilan], Error>) -> Void) {
        let url = URL(string: baseURL)!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            do {
                let bilans = try JSONDecoder().decode([Bilan].self, from: data)
                completion(.success(bilans))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Récupérer un bilan par ID du vendeur
    func getBilanById(vendeurId: String, completion: @escaping (Result<Bilan, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(vendeurId)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            do {
                let bilan = try JSONDecoder().decode(Bilan.self, from: data)
                completion(.success(bilan))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Mise à jour d'un bilan
    func updateBilan(id: String, vendeurId: String, sommeDues: Double, totalFrais: Double, totalCommissions: Double, gains: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "vendeurId": vendeurId,
            "sommeDues": sommeDues,
            "totalFrais": totalFrais,
            "totalCommissions": totalCommissions,
            "gains": gains
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
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
            completion(.success("Bilan modifié avec succès !"))
        }.resume()
    }
    
    // Suppression d'un bilan
    func deleteBilan(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success("Bilan supprimé !"))
        }.resume()
    }
}
