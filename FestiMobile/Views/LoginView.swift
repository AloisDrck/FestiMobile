//
//  LoginView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 22/03/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AdminViewModel()
    @State private var isNavigatingToAdmin = false
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Connexion")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        inputField(title: "Nom d'utilisateur", text: $viewModel.username)
                        inputField(title: "Mot de passe", text: $viewModel.password, isSecure: true)
                    }
                    .padding(.horizontal, 40)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }
                    
                    Button(action: {
                        viewModel.login { success in
                            if success {
                                isLoggedIn = true
                                isNavigatingToAdmin = true
                            }
                        }
                    }) {
                        Text("Se connecter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $isNavigatingToAdmin) {
                AdminView()
            }
        }
    }
    
    private func inputField(title: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            if isSecure {
                SecureField(title, text: text)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
            } else {
                TextField(title, text: text)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}
