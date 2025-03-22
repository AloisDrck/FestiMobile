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
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UtilisateurViewModel
    @Binding var utilisateur: Utilisateur

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
            ScrollView {
                VStack(spacing: 20) {
                    // Section Informations personnelles
                    GroupBox {
                        VStack(spacing: 15) {
                            CustomTextFieldView(placeholder: "Nom", text: $nom, icon: "person.fill")
                            CustomTextFieldView(placeholder: "Prénom", text: $prenom, icon: "person.2.fill")
                            CustomTextFieldView(placeholder: "Email", text: $email, icon: "envelope.fill", keyboardType: .emailAddress)
                            CustomTextFieldView(placeholder: "Téléphone", text: $telephone, icon: "phone.fill", keyboardType: .phonePad)
                            CustomTextFieldView(placeholder: "Adresse", text: $adresse, icon: "house.fill")
                            CustomTextFieldView(placeholder: "Ville", text: $ville, icon: "building.fill")
                            CustomTextFieldView(placeholder: "Code Postal", text: $codePostal, icon: "map.fill", keyboardType: .numberPad)
                            CustomTextFieldView(placeholder: "Pays", text: $pays, icon: "globe")
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // Section Rôle
                    GroupBox {
                        Picker("Rôle", selection: $role) {
                            ForEach([RoleUtilisateur.acheteur, RoleUtilisateur.vendeur], id: \.self) { role in
                                Text(role.rawValue).tag(role)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // Enregistrer les modifications
                    Button(action: saveUser) {
                        Text("Enregistrer les modifications")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .padding(.top, 20)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom))
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Modifier l'utilisateur")
        .navigationBarTitleDisplayMode(.inline)
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
