//
//  DepotView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//

import SwiftUI

struct DepotView: View {
    @State private var jeux: [JeuDepot] = []
    @Binding var utilisateur: Utilisateur
    @State private var showAjouterJeuView = false
    
    @StateObject private var viewModel = JeuDepotViewModel()
    @StateObject private var bilanviewModel = BilanViewModel()

    
    @State private var showConfirmationAlert = false
    @State private var totalFraisDepot: Double = 0.0

    var body: some View {
        NavigationView {
            VStack {
                if jeux.isEmpty {
                    VStack {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("Aucun jeu ajouté")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(jeux) { jeu in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(jeu.nomJeu)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Text("Éditeur: \(jeu.editeurJeu)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Text("Prix: \(jeu.prixJeu, specifier: "%.2f") €")
                                        .font(.subheadline)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Text("Quantité: \(jeu.quantiteJeuDisponible)")
                                        .font(.subheadline)
                                }
                                HStack {
                                    Text("Remise: \(jeu.remiseDepot, specifier: "%.2f") %")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    
                                    Spacer()
                                    
                                    Text("Frais: \(jeu.fraisDepot, specifier: "%.2f") €")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                    
                                }
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: supprimerJeu)
                    }
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    Button(action: {
                        showAjouterJeuView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Ajouter un jeu")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if !jeux.isEmpty {
                        Button(action: {
                            totalFraisDepot = jeux.reduce(0) { $0 + $1.fraisDepot }
                            showConfirmationAlert.toggle()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Confirmer")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showAjouterJeuView) {
                AddJeuView(jeux: $jeux, utilisateur: $utilisateur)
            }
            
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Confirmer le dépôt"),
                    message: Text("Frais totaux des jeux déposés: \(totalFraisDepot, specifier: "%.2f") €"),
                    primaryButton: .destructive(Text("Confirmer")) {
                        confirmerDepot()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle("Dépôt de Jeux")
    }

    private func supprimerJeu(at offsets: IndexSet) {
        jeux.remove(atOffsets: offsets)
    }
    
    private func confirmerDepot() {
        // Calculer une seule fois les frais et la somme dues
        let totalFrais = calculerTotalFrais()
        let sommeDues = calculerSommeDues()
        
        // Boucle sur les jeux pour les ajouter et mettre à jour le bilan
        for jeu in jeux {
            viewModel.createJeuDepot(jeuDepot: jeu) { result in
                switch result {
                case .success(let jeuAjoute):
                    print("Jeu ajouté: \(jeuAjoute.nomJeu)")
                    
                    // Une fois tous les jeux ajoutés, mettre à jour le bilan du vendeur
                    if let vendeurId = utilisateur.id {
                        // Utilisation du ViewModel pour récupérer le bilan du vendeur
                        bilanviewModel.getBilanById(vendeurId: vendeurId) { result in
                            switch result {
                            case .success(let bilan):
                                // Calculer les valeurs actuelles des commissions et gains
                                let totalCommissions = bilan.totalCommissions
                                let gains = bilan.gains
                                
                                // Mettre à jour le bilan avec les nouvelles valeurs
                                guard let bilanId = bilan.id else {
                                    print("Erreur: Bilan sans ID")
                                    return
                                }
                                
                                bilanviewModel.updateBilan(
                                    id: bilanId,
                                    vendeurId: vendeurId,
                                    sommeDues: sommeDues,
                                    totalFrais: totalFrais,
                                    totalCommissions: totalCommissions,
                                    gains: gains
                                ) { updateResult in
                                    switch updateResult {
                                    case .success(let message):
                                        print("Bilan mis à jour: \(message)")
                                    case .failure(let error):
                                        print("Erreur lors de la mise à jour du bilan: \(error.localizedDescription)")
                                    }
                                }
                            case .failure(let error):
                                print("Erreur lors de la récupération du bilan: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("Erreur lors de l'ajout du jeu: \(error.localizedDescription)")
                }
            }
        }
        
        // Vider les jeux une fois le dépôt confirmé
        jeux.removeAll()
    }

    
    private func calculerTotalFrais() -> Double {
        var totalFrais = 0.0
        for jeu in jeux {
            totalFrais += jeu.fraisDepot
        }
        return totalFrais
    }

    private func calculerSommeDues() -> Double {
        var sommeDues = 0.0
        for jeu in jeux {
            sommeDues += jeu.fraisDepot
        }
        return sommeDues
    }
}
