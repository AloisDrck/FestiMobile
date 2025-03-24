//
//  Vente.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

// Type intermediaire pour correspondre à la structure de la réponse du backend (message, vente)
struct VenteResponse: Codable {
    var message: String
    var vente: Vente
}

struct Vente: Codable, Identifiable {
    var id: String
    var acheteur: String // ID Utilisateur
    var vendeur: String // ID Utilisateur
    var commissionVente: Double
    var dateVente: Date
    var montantTotal: Double
    var acheteurNom: String?
    var acheteurPrenom: String?
    var vendeurNom: String?
    var vendeurPrenom: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case acheteur, vendeur, commissionVente, dateVente, montantTotal
    }
    
    // Décodeur personnalisé pour la date
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    init(id: String, acheteur: String, vendeur: String, commissionVente: Double, dateVente: Date, montantTotal: Double, acheteurNom: String? = nil, acheteurPrenom: String? = nil, vendeurNom: String? = nil, vendeurPrenom: String? = nil) {
        self.id = id
        self.acheteur = acheteur
        self.vendeur = vendeur
        self.commissionVente = commissionVente
        self.dateVente = dateVente
        self.montantTotal = montantTotal
        self.acheteurNom = acheteurNom
        self.acheteurPrenom = acheteurPrenom
        self.vendeurNom = vendeurNom
        self.vendeurPrenom = vendeurPrenom
    }
    
    // Décodeur personnalisé qui utilise le dateFormatter pour décoder la date
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Décodage des propriétés
        id = try container.decode(String.self, forKey: .id)
        acheteur = try container.decode(String.self, forKey: .acheteur)
        vendeur = try container.decode(String.self, forKey: .vendeur)
        commissionVente = try container.decode(Double.self, forKey: .commissionVente)
        montantTotal = try container.decode(Double.self, forKey: .montantTotal)
        
        // Décodage personnalisé de la date
        let dateString = try container.decode(String.self, forKey: .dateVente)
        if let date = Vente.dateFormatter.date(from: dateString) {
            dateVente = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dateVente, in: container, debugDescription: "Date format is invalid")
        }
    }
}
