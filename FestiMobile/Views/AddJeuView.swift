//
//  AddJeuView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct AddJeuView: View {
    @Binding var jeux: [JeuDepot]
    @Binding var utilisateur: Utilisateur
    
    @State private var nomJeu = ""
    @State private var editeurJeu = ""
    @State private var prixJeu = ""
    @State private var quantite = ""
    @State private var remiseDepot = ""
    @State private var statutJeu: StatutJeu = .disponible
    
    @StateObject private var viewModel = SessionViewModel()
    
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Ajouter un jeu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                inputField(title: "Nom du jeu", text: $nomJeu)
                inputField(title: "Éditeur", text: $editeurJeu)
                inputField(title: "Prix (€)", text: $prixJeu, keyboard: .decimalPad)
                inputField(title: "Quantité", text: $quantite, keyboard: .numberPad)
                inputField(title: "Remise (%)", text: $remiseDepot, keyboard: .decimalPad)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: ajouterJeu) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                        Text("Ajouter")
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
        }
        .onAppear {
            viewModel.fetchSessionEnCours()
        }
    }
    
    private func inputField(title: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            TextField(title, text: text)
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(10)
                .keyboardType(keyboard)
        }
        .padding(.horizontal)
    }
    
    private func ajouterJeu() {
        errorMessage = nil
        
        guard !nomJeu.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Le nom du jeu ne peut pas être vide."
            return
        }
        guard !editeurJeu.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "L'éditeur du jeu ne peut pas être vide."
            return
        }
        guard let prixDouble = Double(prixJeu), prixDouble > 0 else {
            errorMessage = "Le prix doit être supérieur à 0 €."
            return
        }
        guard let quantiteInt = Int(quantite), quantiteInt > 0 else {
            errorMessage = "La quantité doit être supérieure à 0."
            return
        }
        guard let remiseDouble = Double(remiseDepot), remiseDouble >= 0, remiseDouble <= 100 else {
            errorMessage = "La remise doit être entre 0 et 100 %."
            return
        }
        guard let utilisateurId = utilisateur.id else {
            errorMessage = "Erreur: L'utilisateur n'a pas d'ID valide."
            return
        }
        guard let session = viewModel.session else {
            errorMessage = "Erreur: Aucune session en cours."
            return
        }
        
        let fraisDepot = session.fraisDepot
        let frais_depot = prixDouble * (fraisDepot / 100)
        let frais_jeu_totale = frais_depot * Double(quantiteInt)
        let frais_jeu_apres_remise = frais_jeu_totale - (frais_jeu_totale * remiseDouble / 100)
        
        let nouveauJeu = JeuDepot(
            vendeur: utilisateurId,
            nomJeu: nomJeu,
            editeurJeu: editeurJeu,
            prixJeu: prixDouble,
            quantiteJeuDisponible: quantiteInt,
            quantiteJeuVendu: 0,
            statutJeu: statutJeu,
            fraisDepot: frais_jeu_apres_remise,
            remiseDepot: remiseDouble
        )
        
        jeux.append(nouveauJeu)
        
        nomJeu = ""
        editeurJeu = ""
        prixJeu = ""
        quantite = ""
        remiseDepot = ""
    }
}
