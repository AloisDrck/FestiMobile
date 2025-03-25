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
    
//    Créer une vente.
//    Entrées :
//    - vente (Vente) : L'objet de vente à créer.
//    - jeuxVendus ([VenteJeu]) : Liste des jeux vendus associés à la vente.
//    - completion (Closure) : Retourne une réponse (`Vente`) en cas de succès ou une erreur (`Error`).
//
//    Sorties :
//    - Succès : Retourne l'objet `Vente` créé.
//    - Échec : Retourne une erreur (`Error`), incluant des erreurs liées à la création de la vente ou à la sérialisation des données.
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
    
//    Récupérer toutes les ventes.
//    Entrées :
//    - completion (Closure) : Retourne une liste de ventes (`[Vente]`) ou une erreur (`Error`).
//
//    Sorties :
//    - Succès : Retourne une liste de ventes.
//    - Échec : Retourne une erreur (`Error`), incluant des erreurs liées à la récupération des ventes.
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
    
//    Récupérer les ventes d'un acheteur donné par ID.
//    Entrées :
//    - acheteurId (String) : L'ID de l'acheteur pour lequel récupérer les ventes.
//    - completion (Closure) : Retourne une liste de ventes (`[Vente]`) ou une erreur (`Error`).
//
//    Sorties :
//    - Succès : Retourne une liste de ventes effectuées par l'acheteur.
//    - Échec : Retourne une erreur (`Error`), incluant des erreurs liées à la récupération des ventes de l'acheteur.
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
    
//    Récupérer les ventes d'un vendeur donné par ID.
//    Entrées :
//    - vendeurId (String) : L'ID du vendeur pour lequel récupérer les ventes.
//    - completion (Closure) : Retourne une liste de ventes (`[Vente]`) ou une erreur (`Error`).
//
//    Sorties :
//    - Succès : Retourne une liste de ventes effectuées par le vendeur.
//    - Échec : Retourne une erreur (`Error`), incluant des erreurs liées à la récupération des ventes du vendeur.
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
