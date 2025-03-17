//
//  Vente.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

struct Vente: Codable, Identifiable {
    var id: String?
    var acheteur: String // ID Utilisateur
    var vendeur: String // ID Utilisateur
    var commissionVente: Double
    var dateVente: Date
    var montantTotal: Double
}
