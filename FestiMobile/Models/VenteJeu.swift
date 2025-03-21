//
//  VenteJeu.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//


struct VenteJeu: Codable, Identifiable {
    var id: String
    var idJeuDepot: String // ID JeuDepot
    var idVente: String // ID Vente
    var quantiteVendus: Int
    var nomJeu: String?
    var editeurJeu: String?
    var prixJeu: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case idJeuDepot, idVente, quantiteVendus
    }
}
