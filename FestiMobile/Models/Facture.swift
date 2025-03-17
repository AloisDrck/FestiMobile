//
//  Facture.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

struct Facture: Codable, Identifiable {
    var id: String?
    var acheteur: String // ID Utilisateur
    var idVente: String // ID Vente
    var dateFacture: Date
    var montantTotal: Double
}
