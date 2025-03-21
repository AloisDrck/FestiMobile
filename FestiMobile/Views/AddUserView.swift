//
//  AddUserView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct AddUserView: View {
    @State private var nom = ""
    @State private var prenom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var codePostal = ""
    @State private var pays = ""
    @State private var role: RoleUtilisateur = .vendeur
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UtilisateurViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Nom", text: $nom)
                    TextField("Prénom", text: $prenom)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $telephone)
                        .keyboardType(.phonePad)
                    TextField("Adresse", text: $adresse)
                    TextField("Ville", text: $ville)
                    TextField("Code Postal", text: $codePostal)
                        .keyboardType(.numberPad)
                    TextField("Pays", text: $pays)
                }
                
                Section(header: Text("Rôle")) {
                    Picker("Rôle", selection: $role) {
                        ForEach([RoleUtilisateur.vendeur, RoleUtilisateur.acheteur], id: \.self) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                
                Button(action: saveUser) {
                    Text("Ajouter l'utilisateur")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Ajouter un utilisateur")
    }
    
    private func saveUser() {
        guard !nom.isEmpty, !prenom.isEmpty, !email.isEmpty else {
            alertMessage = "Tous les champs doivent être remplis."
            isShowingAlert = true
            return
        }
        
        let newUser = Utilisateur(id: UUID().uuidString, nom: nom, prenom: prenom, mail: email, telephone: telephone, adresse: adresse, ville: ville, codePostal: codePostal, pays: pays, role: role)
        
        // Appel au ViewModel pour créer l'utilisateur
        viewModel.createUser(newUser)
        
        // Réinitialisation du formulaire
        nom = ""
        prenom = ""
        email = ""
        telephone = ""
        adresse = ""
        ville = ""
        codePostal = ""
        pays = ""
        role = .vendeur
        
        // Fermer la vue après ajout
        dismiss()
    }
}
