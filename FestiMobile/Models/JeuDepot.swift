//
//  JeuDepot.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

struct JeuDepot: Codable, Identifiable {
    var id: String?
    var vendeur: String // ID Utilisateur
    var nomJeu: String
    var editeurJeu: String
    var prixJeu: Double
    let quantiteJeuDisponible: Int
    let quantiteJeuVendu: Int
    var statutJeu: StatutJeu
    var dateDepot: Date
    var fraisDepot: Double
    var remiseDepot: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vendeur, nomJeu, editeurJeu, prixJeu, quantiteJeuDisponible, quantiteJeuVendu, statutJeu, dateDepot, fraisDepot, remiseDepot
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        vendeur = try container.decode(String.self, forKey: .vendeur)
        nomJeu = try container.decode(String.self, forKey: .nomJeu)
        editeurJeu = try container.decode(String.self, forKey: .editeurJeu)
        prixJeu = try container.decode(Double.self, forKey: .prixJeu)
        quantiteJeuDisponible = try container.decode(Int.self, forKey: .quantiteJeuDisponible)
        quantiteJeuVendu = try container.decode(Int.self, forKey: .quantiteJeuVendu)
        statutJeu = try container.decode(StatutJeu.self, forKey: .statutJeu)
        fraisDepot = try container.decode(Double.self, forKey: .fraisDepot)
        remiseDepot = try container.decode(Double.self, forKey: .remiseDepot)

        // Décoder la date avec un `DateFormatter`
        let dateString = try container.decode(String.self, forKey: .dateDepot)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            dateDepot = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dateDepot, in: container, debugDescription: "Format de date invalide")
        }
    }
}

enum StatutJeu: String, Codable {
    case disponible = "Disponible"
    case vendu = "Vendu"
}
