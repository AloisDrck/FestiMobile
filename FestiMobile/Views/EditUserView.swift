//
//  EditUserView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 17/03/2025.
//

import SwiftUI

struct EditUserView: View {
    @State private var nom: String
    @State private var prenom: String
    @State private var email: String
    @State private var telephone: String
    @State private var adresse: String
    @State private var ville: String
    @State private var codePostal: String
    @State private var pays: String
    @State private var role: RoleUtilisateur
    
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) private var dismiss  // Permet de fermer la vue après l'édition
    @ObservedObject var viewModel: UtilisateurViewModel  // ViewModel pour gérer les utilisateurs
    @Binding var utilisateur: Utilisateur  // L'utilisateur à modifier

    // Initialisation des propriétés @State à partir de l'utilisateur
    init(utilisateur: Binding<Utilisateur>, viewModel: UtilisateurViewModel) {
        self._utilisateur = utilisateur
        self._nom = State(initialValue: utilisateur.wrappedValue.nom)
        self._prenom = State(initialValue: utilisateur.wrappedValue.prenom)
        self._email = State(initialValue: utilisateur.wrappedValue.mail)
        self._telephone = State(initialValue: utilisateur.wrappedValue.telephone ?? "")
        self._adresse = State(initialValue: utilisateur.wrappedValue.adresse ?? "")
        self._ville = State(initialValue: utilisateur.wrappedValue.ville ?? "")
        self._codePostal = State(initialValue: utilisateur.wrappedValue.codePostal ?? "")
        self._pays = State(initialValue: utilisateur.wrappedValue.pays ?? "")
        self._role = State(initialValue: utilisateur.wrappedValue.role)
        
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

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
                    Text("Enregistrer les modifications")
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
        .navigationTitle("Modifier l'utilisateur")
    }
    
    // Fonction pour enregistrer les modifications
    private func saveUser() {
        guard !nom.isEmpty, !prenom.isEmpty, !email.isEmpty else {
            alertMessage = "Tous les champs doivent être remplis."
            isShowingAlert = true
            return
        }
        
        utilisateur.nom = nom
        utilisateur.prenom = prenom
        utilisateur.mail = email
        utilisateur.telephone = telephone
        utilisateur.adresse = adresse
        utilisateur.ville = ville
        utilisateur.codePostal = codePostal
        utilisateur.pays = pays
        utilisateur.role = role
        
        // Appel au ViewModel pour mettre à jour l'utilisateur
        viewModel.updateUser(utilisateur)
        
        // Fermer la vue après modification
        dismiss()
    }
}
