//
//  Buyer.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct BuyerView: View {
    @StateObject private var viewModel = UtilisateurViewModel()  // Utilisation du ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Affichage d'un message d'erreur si un problème survient
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Affichage des acheteurs avec ForEach
                List {
                    ForEach($viewModel.acheteurs) { $acheteur in
                        NavigationLink(destination: UserDetailView(utilisateur: $acheteur)) {
                            VStack(alignment: .leading) {
                                Text("\(acheteur.nom) \(acheteur.prenom)")
                                    .font(.headline)
                                Text(acheteur.mail)
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .onAppear {
                // Chargement des acheteurs dès l'apparition de la vue
                viewModel.fetchBuyers()
            }
        }
        .navigationTitle("Liste des acheteurs")
    }
    
    // Fonction de suppression
    private func delete(at offsets: IndexSet) {
        // Supprimer localement avant d'envoyer la requête au backend
        let acheteursToDelete = offsets.map { viewModel.acheteurs[$0] }
        
        // Supprimer les acheteurs localement
        viewModel.acheteurs.remove(atOffsets: offsets)
        
        // Appeler la suppression côté serveur pour chaque acheteur
        for acheteur in acheteursToDelete {
            viewModel.deleteUser(id: acheteur.id) { success, error in
                if success {
                    // Vous pouvez gérer un succès ici si nécessaire
                } else if let error = error {
                    // Gérer l'erreur si besoin
                    DispatchQueue.main.async {
                        viewModel.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
