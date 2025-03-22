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
    var dateDepot: Date?
    var fraisDepot: Double
    var remiseDepot: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vendeur, nomJeu, editeurJeu, prixJeu, quantiteJeuDisponible, quantiteJeuVendu, statutJeu, dateDepot, fraisDepot, remiseDepot
    }
    
    init(id: String? = nil, vendeur: String, nomJeu: String, editeurJeu: String, prixJeu: Double, quantiteJeuDisponible: Int, quantiteJeuVendu: Int, statutJeu: StatutJeu, dateDepot: Date? = nil, fraisDepot: Double, remiseDepot: Double) {
        self.id = id
        self.vendeur = vendeur
        self.nomJeu = nomJeu
        self.editeurJeu = editeurJeu
        self.prixJeu = prixJeu
        self.quantiteJeuDisponible = quantiteJeuDisponible
        self.quantiteJeuVendu = quantiteJeuVendu
        self.statutJeu = statutJeu
        self.dateDepot = dateDepot
        self.fraisDepot = fraisDepot
        self.remiseDepot = remiseDepot
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

        if let dateString = try container.decodeIfPresent(String.self, forKey: .dateDepot) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: dateString) {
                dateDepot = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .dateDepot, in: container, debugDescription: "Format de date invalide")
            }
        }
    }
    
    // Encoder la date au format ISO8601 lors de l'encodage
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(vendeur, forKey: .vendeur)
        try container.encode(nomJeu, forKey: .nomJeu)
        try container.encode(editeurJeu, forKey: .editeurJeu)
        try container.encode(prixJeu, forKey: .prixJeu)
        try container.encode(quantiteJeuDisponible, forKey: .quantiteJeuDisponible)
        try container.encode(quantiteJeuVendu, forKey: .quantiteJeuVendu)
        try container.encode(statutJeu, forKey: .statutJeu)
        try container.encode(fraisDepot, forKey: .fraisDepot)
        try container.encode(remiseDepot, forKey: .remiseDepot)
        
        // Encoder la date avec le format ISO8601
        if let dateDepot = dateDepot {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let dateString = formatter.string(from: dateDepot)
            try container.encode(dateString, forKey: .dateDepot)
        }
    }
}

enum StatutJeu: String, Codable {
    case disponible = "Disponible"
    case vendu = "Vendu"
    case supprime = "Supprimé"
}
