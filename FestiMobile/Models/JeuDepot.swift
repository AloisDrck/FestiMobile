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
    var quantiteJeu: Int
    var statutJeu: StatutJeu
    var dateDepot: Date
    var fraisDepot: Double
    var remiseDepot: Double
}

enum StatutJeu: String, Codable {
    case disponible = "Disponible"
    case vendu = "Vendu"
}
