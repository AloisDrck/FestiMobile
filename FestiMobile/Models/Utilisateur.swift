//
//  Utilisateur.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

struct Utilisateur: Codable, Identifiable {
    var id: String?
    var nom: String
    var prenom: String
    var mail: String
    var telephone: String?
    var adresse: String?
    var role: RoleUtilisateur
}

enum RoleUtilisateur: String, Codable {
    case admin = "Admin"
    case vendeur = "Vendeur"
    case acheteur = "Acheteur"
    case gestionnaire = "Gestionnaire"
}
