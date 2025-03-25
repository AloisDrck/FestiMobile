//
//  VenteViewModel.swift
//  FestiMobile
//
//  Created by Zolan Givre on 18/03/2025.
//

import Foundation
import Combine

class VenteViewModel: ObservableObject {
    @Published var ventes: [Vente] = []
    @Published var errorMessage: String? = nil
    @Published var jeuxSelectionnes: [JeuDepot] = []
    private let utilisateurService = UtilisateurService()
    private let venteService = VenteService()

    // Récupérer les ventes d'un utilisateur (vendeur ou acheteur) par son ID et son rôle.
    // Entrées :
    // - id (String) : L'ID de l'utilisateur (vendeur ou acheteur).
    // - role (RoleUtilisateur) : Le rôle de l'utilisateur, soit vendeur, soit acheteur.
    // Sorties :
    // - Succès : La liste `ventes` est mise à jour avec les ventes récupérées pour cet utilisateur, et les noms des vendeurs et acheteurs sont assoc

    func fetchVentes(id: String, role: RoleUtilisateur) {
        if role == .vendeur {
            venteService.getVentesByVendeurId(vendeurId: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ventes):
                        self?.fetchUtilisateursAndUpdateVentes(ventes: ventes, role: role)
                    case .failure(let error):
                        self?.errorMessage = "Erreur : \(error.localizedDescription)"
                    }
                }
            }
        } else if role == .acheteur {
            venteService.getVentesByAcheteurId(acheteurId: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ventes):
                        self?.fetchUtilisateursAndUpdateVentes(ventes: ventes, role: role)
                    case .failure(let error):
                        self?.errorMessage = "Erreur : \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    // Récupère tous les utilisateurs et met à jour les ventes avec les noms des vendeurs et des acheteurs.
    // Entrées :
    // - ventes ([Vente]) : Liste des ventes à mettre à jour avec les informations des utilisateurs.
    // - role (RoleUtilisateur) : Le rôle de l'utilisateur (vendeur ou acheteur), utilisé pour déterminer le contexte, bien que ce paramètre ne soit pas directement utilisé dans la fonction.
    // Sorties :
    // - Succès : La liste `ventes` est mise à jour avec les noms des vendeurs et des acheteurs, extraits des utilisateurs récupérés.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit lors de la récupération des utilisateurs.

    private func fetchUtilisateursAndUpdateVentes(ventes: [Vente], role: RoleUtilisateur) {
        // Récupérer tous les utilisateurs
        utilisateurService.getAllUsers { [weak self] utilisateurs, error in
            guard let self = self, let utilisateurs = utilisateurs else {
                self?.errorMessage = "Erreur de récupération des utilisateurs."
                return
            }
            
            // Créer un dictionnaire pour accéder rapidement aux utilisateurs par leur ID
            let utilisateursDict = Dictionary(uniqueKeysWithValues: utilisateurs.map { ($0.id, $0) })
            
            // Mettre à jour les ventes avec les noms des acheteurs ou vendeurs
            self.ventes = ventes.map { vente in
                var updatedVente = vente
                if let utilisateurVendeur = utilisateursDict[vente.vendeur] {
                    updatedVente.vendeurNom = utilisateurVendeur.nom
                    updatedVente.vendeurPrenom = utilisateurVendeur.prenom
                }
                if let utilisateurAcheteur = utilisateursDict[vente.acheteur] {
                    updatedVente.acheteurNom = utilisateurAcheteur.nom
                    updatedVente.acheteurPrenom = utilisateurAcheteur.prenom
                }
                return updatedVente
            }
        }
    }
    
    // Créer une nouvelle vente avec des jeux associés.
    // Entrées :
    // - vente (Vente) : La vente à créer, contenant les détails de la transaction.
    // - jeuxVendus ([VenteJeu]) : La liste des jeux associés à la vente.
    // - completion (Bool) : Un bloc de complétion qui est appelé avec un succès ou un échec de la création.
    // Sorties :
    // - Succès : La vente est ajoutée à la liste `ventes` si l'opération est réussie.
    // - Échec : Un message d'erreur est stocké dans `errorMessage` si une erreur se produit lors de la création de la vente, et le bloc de complétion retourne `false`.

    func createVente(vente: Vente, jeuxVendus: [VenteJeu], completion: @escaping (Bool) -> Void) {
        venteService.createVente(vente: vente, jeuxVendus: jeuxVendus) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nouvelleVente):
                    self?.ventes.append(nouvelleVente)
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = "Erreur : \(error.localizedDescription)"
                    print("Erreur lors de la création de la vente (VenteViewModel): \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
