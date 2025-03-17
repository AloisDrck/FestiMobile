//
//  JeuDepotService.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 13/03/2025.
//


import Foundation

class JeuDepotService: ObservableObject {

    func fetchItems(completion: @escaping ([JeuDepot]) -> Void) {
        guard let url = URL(string: "https://festivawin-back-16b79a35ef75.herokuapp.com/api/jeuDepot") else { return }
        
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

//    func filterItems(searchTerm: String, minPrice: Double?, maxPrice: Double?, availability: String) {
//        DispatchQueue.main.async {
//            self.filteredItems = self.items.filter { item in
//                let matchesSearch = searchTerm.isEmpty || item.nomJeu.lowercased().contains(searchTerm.lowercased())
//                let matchesMinPrice = minPrice == nil || item.prixJeu >= minPrice!
//                let matchesMaxPrice = maxPrice == nil || item.prixJeu <= maxPrice!
//                let matchesAvailability = availability == "all" || (availability == "Disponible" && item.statutJeu.rawValue == "Disponible") || (availability == "Vendu" && item.statutJeu.rawValue == "Vendu")
//                
//                return matchesSearch && matchesMinPrice && matchesMaxPrice && matchesAvailability
//            }
//        }
//    }
    func filterItems(searchTerm: String, minPrice: Double?, maxPrice: Double?, availability: String, completion: @escaping ([JeuDepot]) -> Void) {
        let queryItems = [
            URLQueryItem(name: "search", value: searchTerm),
            URLQueryItem(name: "minPrice", value: minPrice.map { "\($0)" }),
            URLQueryItem(name: "maxPrice", value: maxPrice.map { "\($0)" }),
            URLQueryItem(name: "availability", value: availability)
        ].compactMap { $0 }

        var urlComponents = URLComponents(string: "http://172.20.10.3:3002/api/jeuDepot")!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let decodedData = try JSONDecoder().decode([JeuDepot].self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print("Erreur de décodage JSON: \(error)")
            }
        }.resume()
    }
}
