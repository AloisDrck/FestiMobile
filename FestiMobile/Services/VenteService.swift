//
//  VenteService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 18/03/2025.
//

import Foundation
import Combine

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
            "montantTotal": vente.montantTotal,
            "commissionVente": vente.commissionVente,
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
//            // Afficher les données brutes reçues pour déboguer
//            if let responseString = String(data: data!, encoding: .utf8) {
//                print("Réponse brute : \(responseString)")
//            }
//            
            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) else {
                let errorMessage = "Erreur HTTP: \(String(describing: response))"
                print(errorMessage)
                completion(.failure(NSError(domain: errorMessage, code: -1, userInfo: nil)))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Données vides", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Décoder la réponse avec le type intermediaire
                let venteResponse = try JSONDecoder().decode(VenteResponse.self, from: data)
                completion(.success(venteResponse.vente)) // Retourner l'objet "vente" extrait de VenteResponse
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
