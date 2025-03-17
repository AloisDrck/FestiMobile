//
//  Utilisateur.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import Foundation

struct Utilisateur: Codable, Identifiable {
    var id: String
    var nom: String
    var prenom: String
    var mail: String
    var telephone: String?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var pays: String?
    var role: RoleUtilisateur
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nom, prenom, mail, telephone, adresse, ville, codePostal, pays, role
    }
}

enum RoleUtilisateur: String, Codable, CaseIterable {
    case admin = "Admin"
    case vendeur = "Vendeur"
    case acheteur = "Acheteur"
    case gestionnaire = "Gestionnaire"
}
