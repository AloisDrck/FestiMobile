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
        var urlComponents = URLComponents(string: "https://festivawin-back-16b79a35ef75.herokuapp.com/api/jeuDepot/filter")
        
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
        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let data = data {
//                do {
//                    let decodedData = try JSONDecoder().decode([JeuDepot].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(decodedData)
//                    }
//                } catch {
//                    print("Erreur de décodage :", error)
//                }
//            }
//        }.resume()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("Réponse brute du backend : \(json)")
                    
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
}
