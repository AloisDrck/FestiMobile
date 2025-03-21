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
    private let utilisateurService = UtilisateurService() // Service pour récupérer les utilisateurs
    private let venteService = VenteService() // Service pour récupérer les ventes

    // Récupérer les ventes d'un vendeur ou acheteur
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

    func createVente(vente: Vente, jeuxVendus: [VenteJeu], completion: @escaping (Bool) -> Void) {
        venteService.createVente(vente: vente, jeuxVendus: jeuxVendus) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nouvelleVente):
                    self?.ventes.append(nouvelleVente)
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = "Erreur : \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
}
