//
//  ListUserView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 19/03/2025.
//

import SwiftUI

struct ListUserView: View {
    @StateObject private var viewModel = UtilisateurViewModel()
    @StateObject private var adminviewModel = AdminViewModel()
    let isAcheteur: Bool
    
    @State private var showDeleteConfirmation = false
    @State private var utilisateurASupprimer: Utilisateur?
    @State private var indexASupprimer: IndexSet?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
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
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 2)
                                    Text(utilisateur.mail)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing) {
                                if adminviewModel.savedUsername == "admin" {
                                    Button {
                                        let index = isAcheteur ?
                                        viewModel.acheteurs.firstIndex(where: { $0.id == utilisateur.id }) :
                                        viewModel.vendeurs.firstIndex(where: { $0.id == utilisateur.id })
                                        
                                        if let index = index {
                                            showDeleteAlert(at: IndexSet([index]))
                                        }
                                    } label: {
                                        Label("Supprimer", systemImage: "trash.fill")
                                    }
                                    .tint(.red)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                NavigationLink(destination: EditUserView(utilisateur: $utilisateur, viewModel: viewModel)) {
                                    Button {
                                    } label: {
                                        Label("Éditer", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
                .onAppear {
                    if isAcheteur {
                        viewModel.fetchBuyers()
                    } else {
                        viewModel.fetchSellers()
                    }
                }
            }
        }
        .navigationTitle(isAcheteur ? "Liste des acheteurs" : "Liste des vendeurs")
        .alert("Supprimer cet utilisateur ?", isPresented: $showDeleteConfirmation) {
            Button("Annuler", role: .cancel) {
                utilisateurASupprimer = nil
                indexASupprimer = nil
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
            
            showDeleteConfirmation = true
        }
    }
    
    private func deleteUser(_ utilisateur: Utilisateur) {
        guard let utilisateurId = utilisateur.id else { return }
        viewModel.deleteUser(id: utilisateurId) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Suppression locale après la confirmation de la suppression réussie
                    if let index = indexASupprimer?.first {
                        if isAcheteur {
                            viewModel.acheteurs.remove(at: index)
                        } else {
                            viewModel.vendeurs.remove(at: index)
                        }
                    }
                } else {
                    // Affichage d'une erreur si la suppression échoue
                    viewModel.errorMessage = "Erreur : \(error?.localizedDescription ?? "Suppression échouée")"
                }
                utilisateurASupprimer = nil
            }
        }
    }

}
