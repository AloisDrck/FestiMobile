//
//  Admin.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//


struct Admin: Codable, Identifiable {
    var id: String?
    var username: String
    var password: String
    var statut: StatutUtilisateur
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, password, statut
    }
}

struct LoginResponse: Codable {
    let message: String
    let token: String?
}

enum StatutUtilisateur: String, Codable {
    case admin = "Admin"
    case gestionnaire = "Gestionnaire"
}
