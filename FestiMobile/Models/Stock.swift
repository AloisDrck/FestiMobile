//
//  Stock.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

struct Stock: Codable, Identifiable {
    var id: String?
    var idUtilisateur: String // ID Utilisateur
    var idJeuDepot: String // ID JeuDepot
    var quantiteStock: Int
}
