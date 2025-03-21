//
//  ListUserView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 19/03/2025.
//

import SwiftUI

struct ListUserView: View {
    @StateObject private var viewModel = UtilisateurViewModel()
    let isAcheteur: Bool
    
    @State private var showDeleteConfirmation = false
    @State private var utilisateurASupprimer: Utilisateur?
    @State private var indexASupprimer: IndexSet?
    @State private var utilisateurTemporaire: Utilisateur?
    @State private var indexTemporaire: Int?

    
    var body: some View {
        NavigationView {
            VStack {
                // Affichage d'un message d'erreur si un problème survient
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Affichage des utilisateurs avec ForEach
                List {
                    ForEach(isAcheteur ? $viewModel.acheteurs : $viewModel.vendeurs) { $utilisateur in
                        NavigationLink(destination: UserDetailView(utilisateur: $utilisateur)) {
                            VStack(alignment: .leading) {
                                Text("\(utilisateur.nom) \(utilisateur.prenom)")
                                    .font(.headline)
                                Text(utilisateur.mail)
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            // Action qui se déclenche lorsque l'utilisateur glisse vers la droite
                            NavigationLink(destination: EditUserView(utilisateur: $utilisateur, viewModel: viewModel)) {
                                Button {
                                } label: {
                                    Label("Éditer", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .onDelete(perform: showDeleteAlert)
                }
            }
            .onAppear {
                // Chargement des utilisateurs selon s'il s'agit d'acheteurs ou de vendeurs
                if isAcheteur {
                    viewModel.fetchBuyers()
                } else {
                    viewModel.fetchSellers()
                }
            }
        }
        .navigationTitle(isAcheteur ? "Liste des acheteurs" : "Liste des vendeurs")
        .alert("Supprimer cet utilisateur ?", isPresented: $showDeleteConfirmation) {
            Button("Annuler", role: .cancel) {
                // Remet l'utilisateur dans la liste s'il a été supprimé localement
                if let utilisateurTemp = utilisateurTemporaire, let index = indexTemporaire {
                    if isAcheteur {
                        viewModel.acheteurs.insert(utilisateurTemp, at: index)
                    } else {
                        viewModel.vendeurs.insert(utilisateurTemp, at: index)
                    }
                }
                utilisateurASupprimer = nil
                utilisateurTemporaire = nil
                indexTemporaire = nil
            }
            Button("Supprimer", role: .destructive) {
                if let utilisateur = utilisateurASupprimer {
                    deleteUser(utilisateur)
                }
            }
        } message: {
            if let utilisateur = utilisateurASupprimer {
                Text("Cette action est irréversible. Voulez-vous vraiment supprimer \(utilisateur.nom) \(utilisateur.prenom) ?")
            } else {
                Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?")
            }
        }
    }
    
    private func showDeleteAlert(at offsets: IndexSet) {
        if let index = offsets.first {
            utilisateurASupprimer = isAcheteur ? viewModel.acheteurs[index] : viewModel.vendeurs[index]
            indexASupprimer = offsets
            
            // Stocker temporairement l'utilisateur et l'index avant suppression locale
            utilisateurTemporaire = utilisateurASupprimer
            indexTemporaire = index
            
            // Supprimer localement pour l'effet instantané
            if isAcheteur {
                viewModel.acheteurs.remove(at: index)
            } else {
                viewModel.vendeurs.remove(at: index)
            }
            
            showDeleteConfirmation = true
        }
    }

    
    private func deleteUser(_ utilisateur: Utilisateur) {
        viewModel.deleteUser(id: utilisateur.id) { success, error in
            DispatchQueue.main.async {
                if !success, let utilisateurTemp = utilisateurTemporaire, let index = indexTemporaire {
                    // Si la suppression échoue, on remet l'utilisateur dans la liste
                    if isAcheteur {
                        viewModel.acheteurs.insert(utilisateurTemp, at: index)
                    } else {
                        viewModel.vendeurs.insert(utilisateurTemp, at: index)
                    }
                    viewModel.errorMessage = "Erreur : \(error?.localizedDescription ?? "Suppression échouée")"
                }
                utilisateurASupprimer = nil
                utilisateurTemporaire = nil
                indexTemporaire = nil
            }
        }
    }

}
