//
//  SellerView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct SellerView: View {
    @StateObject private var viewModel = UtilisateurViewModel()  // Utilisation du ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Affichage un message d'erreur si un problème survient
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Affichage des vendeurs avec ForEach
                List {
                    ForEach($viewModel.vendeurs) { $vendeur in
                        NavigationLink(destination: UserDetailView(utilisateur: $vendeur)) {
                            VStack(alignment: .leading) {
                                Text("\(vendeur.nom) \(vendeur.prenom)")
                                    .font(.headline)
                                Text(vendeur.mail)
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            // Action qui se déclenche lorsque l'utilisateur glisse vers la droite
                            NavigationLink(destination: EditUserView(utilisateur: $vendeur, viewModel: viewModel)) {
                                Button {
                                } label: {
                                    Label("Éditer", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .onAppear {
                // Chargement des vendeurs dès l'apparition de la vue
                viewModel.fetchSellers()
            }
        }
        .navigationTitle("Liste des vendeurs")
    }
    
    // Fonction de suppression
    private func delete(at offsets: IndexSet) {
        // Supprimer localement avant d'envoyer la requête au backend
        let vendeursToDelete = offsets.map { viewModel.vendeurs[$0] }
        
        // Supprimer les acheteurs localement
        viewModel.vendeurs.remove(atOffsets: offsets)
        
        // Appeler la suppression côté serveur pour chaque acheteur
        for vendeur in vendeursToDelete {
            viewModel.deleteUser(id: vendeur.id) { success, error in
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
