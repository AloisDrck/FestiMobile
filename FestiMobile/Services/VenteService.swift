//
//  VenteService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 18/03/2025.
//

import Foundation

class VenteService {
    private let baseURL = "https://festivawin-back-16b79a35ef75.herokuapp.com/api/vente"
    
    func createVente(vente: Vente, jeuxVendus: [VenteJeu], completion: @escaping (Result<Vente, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }
        
        let requestData: [String: Any] = [
            "acheteurId": vente.acheteur,
            "vendeurId": vente.vendeur,
            "commissionVente": vente.commissionVente,
            "montantTotal": vente.montantTotal,
            "jeuxVendus": jeuxVendus.map { jeu in
                [
                    "idJeuDepot": jeu.idJeuDepot,
                    "quantiteVendus": jeu.quantiteVendus
                ]
            }
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
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
                completion(.failure(NSError(domain: "Données vides", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let venteResponse = try JSONDecoder().decode(Vente.self, from: data)
                completion(.success(venteResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getAllVentes(completion: @escaping (Result<[Vente], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let ventes = try JSONDecoder().decode([Vente].self, from: data)
                completion(.success(ventes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getVentesByAcheteurId(acheteurId: String, completion: @escaping (Result<[Vente], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/acheteur/\(acheteurId)") else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let ventes = try JSONDecoder().decode([Vente].self, from: data)
                completion(.success(ventes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getVentesByVendeurId(vendeurId: String, completion: @escaping (Result<[Vente], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vendeur/\(vendeurId)") else {
            completion(.failure(NSError(domain: "URL invalide", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let ventes = try JSONDecoder().decode([Vente].self, from: data)
                completion(.success(ventes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
