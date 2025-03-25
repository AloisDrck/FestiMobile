//
//  SellerDepotListView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct SellerDepotListView: View {
    @StateObject private var viewModel = JeuDepotViewModel()
    @Binding var utilisateur: Utilisateur
    
    @State private var selectedJeu: JeuDepot?
    @State private var showPopup = false
    
    @State private var showDeleteConfirmation = false
    @State private var jeuToUpdate: JeuDepot?
    
    @State private var showEditPopup = false
    @State private var jeuToEdit: JeuDepot?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.jeux.isEmpty {
                    Text("Aucun jeu déposé.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        Section(header: Text("Jeux déposés").font(.headline)) {
                            ForEach(viewModel.jeux, id: \.id) { jeu in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(jeu.nomJeu)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        Text("Prix: \(jeu.prixJeu, specifier: "%.2f")€")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .italic()
                                    }
                                    Spacer()
                                    Text(jeu.statutJeu.rawValue)
                                        .foregroundColor(jeu.statutJeu == .disponible ? .green : .red)
                                        .fontWeight(.bold)
                                }
                                .onTapGesture {
                                    selectedJeu = jeu
                                    showPopup = true
                                }
                                .swipeActions(edge: .trailing) {
                                    if jeu.statutJeu == .supprime {
                                        Button(action: {
                                            handleRestore(jeu: jeu)
                                        }) {
                                            Label("Restaurer", systemImage: "plus.circle.fill")
                                        }
                                        .tint(.blue)
                                    } else {
                                        Button(action: {
                                            jeuToUpdate = jeu
                                            showDeleteConfirmation = true
                                        }) {
                                            Label("Supprimer", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button(action: {
                                        jeuToEdit = jeu
                                        showEditPopup = true
                                    }) {
                                        Label("Éditer", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .onDelete(perform: handleSwipeDelete)
                        }
                    }
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .onAppear {
                guard let utilisateurId = utilisateur.id else { return }
                viewModel.fetchJeuxDepotByUserId(userId: utilisateurId)
            }
            .sheet(item: $selectedJeu) { jeu in
                JeuDepotDetailView(jeu: jeu)
            }
            .sheet(isPresented: $showEditPopup) {
                if let jeuToEdit = jeuToEdit {
                    EditJeuView(jeu: jeuToEdit, viewModel: viewModel)
                }
            }
            .padding()
            .background(
                Image("generalBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Confirmer la suppression"),
                    message: Text("Voulez-vous vraiment supprimer ce jeu ?"),
                    primaryButton: .destructive(Text("Supprimer")) {
                        if let jeu = jeuToUpdate, let jeuId = jeu.id {
                            viewModel.updateJeuDepot(jeuId: jeuId, updates: ["statutJeu": StatutJeu.supprime.rawValue]) { result in
                                switch result {
                                case .success(let updatedJeu):
                                    // Mise à jour de la liste locale
                                    if let index = viewModel.jeux.firstIndex(where: { $0.id == jeuId }) {
                                        viewModel.jeux[index] = updatedJeu
                                    }
                                case .failure(let error):
                                    // Gérer l'erreur
                                    print("Erreur de mise à jour : \(error.localizedDescription)")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle("Liste des jeux déposés")
    }
    
    private func handleRestore(jeu: JeuDepot) {
        guard let jeuId = jeu.id else { return }
        viewModel.updateJeuDepot(jeuId: jeuId, updates: ["statutJeu": StatutJeu.disponible.rawValue]) { result in
            switch result {
            case .success(let updatedJeu):
                if let index = viewModel.jeux.firstIndex(where: { $0.id == jeuId }) {
                    viewModel.jeux[index] = updatedJeu
                }
            case .failure(let error):
                print("Erreur de mise à jour : \(error.localizedDescription)")
            }
        }
    }
    
    private func handleSwipeDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            let jeu = viewModel.jeux[index]
            if jeu.statutJeu == .supprime {
                handleRestore(jeu: jeu)
            } else {
                jeuToUpdate = jeu
                showDeleteConfirmation = true
            }
        }
    }
}
