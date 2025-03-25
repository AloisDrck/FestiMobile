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
            ScrollView {
                VStack(spacing: 10) {
                    // Section Informations personnelles
                    GroupBox {
                        VStack(spacing: 15) {
                            CustomTextFieldView(placeholder: "Nom *", text: $nom, icon: "person.fill")
                            CustomTextFieldView(placeholder: "Prénom *", text: $prenom, icon: "person.2.fill")
                            CustomTextFieldView(placeholder: "Email *", text: $email, icon: "envelope.fill", keyboardType: .emailAddress)
                            CustomTextFieldView(placeholder: "Téléphone", text: $telephone, icon: "phone.fill", keyboardType: .phonePad)
                            CustomTextFieldView(placeholder: "Adresse", text: $adresse, icon: "house.fill")
                            CustomTextFieldView(placeholder: "Ville", text: $ville, icon: "building.fill")
                            CustomTextFieldView(placeholder: "Code Postal", text: $codePostal, icon: "map.fill", keyboardType: .numberPad)
                            CustomTextFieldView(placeholder: "Pays", text: $pays, icon: "globe")
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
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            
                    Button(action: saveUser) {
                        Text("Ajouter l'utilisateur")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .background(
                Image("generalBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Ajouter un utilisateur")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveUser() {
        guard !nom.isEmpty, !prenom.isEmpty, !email.isEmpty else {
            alertMessage = "Nom, prénom et email doivent être remplis."
            isShowingAlert = true
            return
        }
        
        let newUser = Utilisateur(nom: nom, prenom: prenom, mail: email, telephone: telephone, adresse: adresse, ville: ville, codePostal: codePostal, pays: pays, role: role)
        
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
