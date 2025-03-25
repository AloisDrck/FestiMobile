//
//  PanierViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 24/03/2025.
//


import Foundation

class PanierViewModel: ObservableObject {
    @Published var jeuxDansPanier: [VenteJeu] = []
    
    // Méthode pour ajouter un jeu au panier
    func ajouterAuPanier(jeu: JeuDepot) {
        if let index = jeuxDansPanier.firstIndex(where: { $0.idJeuDepot == jeu.id }) {
            let jeuDansPanier = jeuxDansPanier[index]
            // Vérifier si la quantité ajoutée ne dépasse pas la quantité disponible
            let quantiteRestante = jeu.quantiteJeuDisponible - jeuDansPanier.quantiteVendus
            if jeuDansPanier.quantiteVendus < quantiteRestante {
                jeuxDansPanier[index].quantiteVendus += 1
            } else {
                // Afficher un message d'erreur si la quantité maximale est atteinte
                print("Quantité maximale atteinte pour ce jeu.")
            }
        } else {
            let venteJeu = VenteJeu(
                id: UUID().uuidString,
                idJeuDepot: jeu.id ?? "",
                idVente: "", // À remplir au moment de la vente
                quantiteVendus: 1,
                nomJeu: jeu.nomJeu,
                editeurJeu: jeu.editeurJeu,
                prixJeu: jeu.prixJeu
            )
            jeuxDansPanier.append(venteJeu)
        }
    }
    
    func modifierQuantite(jeuId: String, nouvelleQuantite: Int) {
        if let index = jeuxDansPanier.firstIndex(where: { $0.idJeuDepot == jeuId }) {
            jeuxDansPanier[index].quantiteVendus = max(1, nouvelleQuantite)
        }
    }
    
    func retirerDuPanier(jeuId: String) {
        jeuxDansPanier.removeAll { $0.idJeuDepot == jeuId }
    }
}
