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
    
    //    Récupère tous les bilans depuis l'API et retourne une liste de bilans ou une erreur en cas d'échec.
    //
    //    Entrées :
    //    - completion (Closure) : retourne un résultat avec la liste des bilans ou une erreur.
    //
    //    Sorties :
    //    - Succès : Liste de bilans.
    //    - Échec : Retourne une erreur.
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
    
    //    Récupère un bilan spécifique en fonction de l'ID du vendeur depuis l'API et retourne le bilan ou une erreur.
    //
    //    Entrées :
    //    - vendeurId (String) : ID du vendeur dont on veut récupérer le bilan.
    //    - completion (Closure) : retourne un résultat avec le bilan ou une erreur.
    //
    //    Sorties :
    //    - Succès : Bilan du vendeur.
    //    - Échec : Retourne une erreur.
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
    
    //    Description :
    //    Met à jour un bilan existant avec de nouvelles données (somme due, frais, commissions, gains) et retourne un message de succès ou une erreur.
    //
    //    Entrées :
    //    - id (String) : ID du bilan à mettre à jour.
    //    - vendeurId (String) : ID du vendeur associé.
    //    - sommeDues (Double) : Montant des sommes dues.
    //    - totalFrais (Double) : Montant des frais totaux.
    //    - totalCommissions (Double) : Montant des commissions totales.
    //    - gains (Double) : Montant des gains.
    //    - completion (Closure) : retourne un message de succès ou une erreur.
    //
    //    Sorties :
    //    - Succès : Message "Bilan modifié avec succès !".
    //    - Échec : Retourne une erreur.
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
    
    //    Supprime un bilan en fonction de son ID et retourne un message de succès ou une erreur.
    //
    //    Entrées :
    //    - id (String) : ID du bilan à supprimer.
    //    - completion (Closure) : retourne un message de succès ou une erreur.
    //
    //    Sorties :
    //    - Succès : Message "Bilan supprimé !".
    //    - Échec : Retourne une erreur.
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
