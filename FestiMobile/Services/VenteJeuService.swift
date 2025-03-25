//
//  VenteJeuService.swift
//  FestiMobile
//
//  Created by Zolan Givre on 19/03/2025.
//

import Foundation

class VenteJeuService {
    private let jeuDepotService = JeuDepotService()
    
//    Récupérer les jeux vendus pour une vente donnée.
//    Entrées :
//    - idVente (String) : L'ID de la vente pour laquelle récupérer les jeux vendus.
//    - completion (Closure) : Retourne un tableau de jeux vendus (`[VenteJeu]`) ou une erreur (`Error`).
//
//    Sorties :
//    - Succès : Retourne un tableau de jeux vendus avec les détails des jeux (nom, éditeur, prix).
//    - Échec : Retourne une erreur (`Error`), incluant des erreurs liées à la récupération des jeux ou à la récupération des détails du jeu.
    func getJeuxVendusByVenteId(idVente: String, completion: @escaping (Result<[VenteJeu], Error>) -> Void) {
        guard let url = URL(string: "https://festivawin-back-16b79a35ef75.herokuapp.com/api/venteJeu/\(idVente)") else {
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
                var jeuxVendus = try JSONDecoder().decode([VenteJeu].self, from: data)
                
                // Récupérer les détails du jeu pour chaque vente
                let group = DispatchGroup()
                for i in 0..<jeuxVendus.count {
                    group.enter()
                    self.jeuDepotService.fetchJeuDepotById(jeuId: jeuxVendus[i].idJeuDepot) { result in
                        switch result {
                        case .success(let jeuDepot):
                            jeuxVendus[i].nomJeu = jeuDepot.nomJeu
                            jeuxVendus[i].editeurJeu = jeuDepot.editeurJeu
                            jeuxVendus[i].prixJeu = jeuDepot.prixJeu
                        case .failure(let error):
                            print("Erreur lors de la récupération du jeu: \(error.localizedDescription)")
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(jeuxVendus))
                }
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
