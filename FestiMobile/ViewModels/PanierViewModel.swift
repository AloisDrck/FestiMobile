//
//  PanierViewModel.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 24/03/2025.
//


import Foundation

class PanierViewModel: ObservableObject {
    @Published var jeuxDansPanier: [VenteJeu] = []
    
    // Ajouter un jeu au panier ou augmenter la quantité si le jeu est déjà présent.
    // Entrées :
    // - jeu (JeuDepot) : L'objet `JeuDepot` représentant le jeu à ajouter au panier.
    // - Aucun retour explicite, la mise à jour se fait directement dans la méthode.
    //
    // Sorties :
    // - Succès : Le jeu est ajouté au panier ou la quantité est augmentée si le jeu est déjà présent.
    // - Échec : Si la quantité maximale est atteinte pour ce jeu, un message d'erreur est imprimé dans la console.
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
    
    // Modifier la quantité d'un jeu déjà présent dans le panier.
    // Entrées :
    // - jeuId (String) : L'ID du jeu dont la quantité doit être modifiée.
    // - nouvelleQuantite (Int) : La nouvelle quantité souhaitée pour ce jeu dans le panier.
    //
    // Sorties :
    // - Succès : La quantité du jeu est mise à jour avec la nouvelle valeur, limitée à un minimum de 1.
    // - Échec : Aucun retour explicite, mais la quantité ne peut pas être inférieure à 1.
    func modifierQuantite(jeuId: String, nouvelleQuantite: Int) {
        if let index = jeuxDansPanier.firstIndex(where: { $0.idJeuDepot == jeuId }) {
            jeuxDansPanier[index].quantiteVendus = max(1, nouvelleQuantite)
        }
    }
    
    // Retirer un jeu du panier par son ID.
    // Entrées :
    // - jeuId (String) : L'ID du jeu à supprimer du panier.
    // - Aucun retour explicite, la suppression se fait directement dans la méthode.
    //
    // Sorties :
    // - Succès : Le jeu est supprimé du panier.
    // - Échec : Aucun retour explicite, mais le jeu est retiré si présent dans le panier.
    func retirerDuPanier(jeuId: String) {
        jeuxDansPanier.removeAll { $0.idJeuDepot == jeuId }
    }
}
