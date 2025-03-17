//
//  UserDetailView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct UserDetailView: View {
    @Binding var utilisateur: Utilisateur
    @StateObject private var viewModel = UtilisateurViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Nom: \(utilisateur.nom) \(utilisateur.prenom)")
                    .font(.title)
                    .padding(.top)
                
                Text("Email: \(utilisateur.mail)")
                    .font(.body)
                
                if let telephone = utilisateur.telephone {
                    Text("Téléphone: \(telephone)")
                        .font(.body)
                }
                
                if let adresse = utilisateur.adresse {
                    Text("Adresse: \(adresse)")
                        .font(.body)
                }
                
                if let ville = utilisateur.ville {
                    Text("Ville: \(ville)")
                        .font(.body)
                }
                
                if let codePostal = utilisateur.codePostal {
                    Text("Code Postal: \(codePostal)")
                        .font(.body)
                }
                
                if let pays = utilisateur.pays {
                    Text("Pays: \(pays)")
                        .font(.body)
                }
                
                Text("Rôle: \(utilisateur.role.rawValue)")
                    .font(.body)
                
                NavigationLink(destination: EditUserView(utilisateur: $utilisateur, viewModel: viewModel)) {
                    Text("Modifier")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails de l'utilisateur")
    }
}
