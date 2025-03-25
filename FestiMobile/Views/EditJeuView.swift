//
//  EditJeuView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct EditJeuView: View {
    @State var jeu: JeuDepot
    @ObservedObject var viewModel: JeuDepotViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Modifier le Jeu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            inputField(title: "Nom du jeu", text: $jeu.nomJeu)
            inputField(title: "Éditeur", text: $jeu.editeurJeu)
            
            Button(action: {
                saveJeu()
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                    Text("Sauvegarder")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(
            Image("popupBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            TextField(title, text: text)
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(10)
                .keyboardType(.default)
        }
        .padding(.horizontal)
    }
    
    private func saveJeu() {
        viewModel.updateJeuDepot(jeuId: jeu.id ?? "", updates: ["nomJeu": jeu.nomJeu, "editeurJeu": jeu.editeurJeu]) { result in
            switch result {
            case .success(let updatedJeu):
                // Mise à jour locale
                if let index = viewModel.jeux.firstIndex(where: { $0.id == updatedJeu.id }) {
                    viewModel.jeux[index] = updatedJeu
                }
                // Fermer le popup après la sauvegarde
                dismiss()
            case .failure(let error):
                // Gestion d'erreur
                print("Erreur : \(error.localizedDescription)")
            }
        }
    }
}
