//
//  LoginView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 12/03/2025.
//

import SwiftUI

struct AdminView: View {
    @State private var navigateToBuyer: Bool = false
    @State private var navigateToSeller: Bool = false
    @State private var navigateToAddUser: Bool = false
    @State private var navigateToSessions: Bool = false
    @State private var navigateToGames: Bool = false
    
    @StateObject private var viewModel = AdminViewModel()
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond d'écran
                if viewModel.savedUsername == "admin" {
                    Image("adminBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    
                } else {
                    Image("gestionnaireBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    
                }

                VStack(spacing: 20) {
                    Button {
                        navigateToBuyer = true
                    } label: {
                        Label("Acheter", systemImage: "cart.fill")
                    }
                    .buttonStyle(LargeButtonStyle(backgroundColor: .green))
                    .navigationDestination(isPresented: $navigateToBuyer) {
                        ListUserView(isAcheteur: true)
                    }
                    
                    Button {
                        navigateToSeller = true
                    } label: {
                        Label("Déposer", systemImage: "arrow.down.circle.fill")
                    }
                    .buttonStyle(LargeButtonStyle(backgroundColor: .blue))
                    .navigationDestination(isPresented: $navigateToSeller) {
                        ListUserView(isAcheteur: false)
                    }
                    
                    if viewModel.savedUsername == "admin" {
                        Button {
                            navigateToAddUser = true
                        } label: {
                            Label("Ajouter un utilisateur", systemImage: "person.badge.plus.fill")
                        }
                        .buttonStyle(LargeButtonStyle(backgroundColor: .purple))
                        .navigationDestination(isPresented: $navigateToAddUser) {
                            AddUserView()
                        }
                        
                        Button {
                            navigateToSessions = true
                        } label: {
                            Label("Sessions", systemImage: "clock.fill")
                        }
                        .buttonStyle(LargeButtonStyle(backgroundColor: .orange))
                        .navigationDestination(isPresented: $navigateToSessions) {
                            SessionView()
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 100)
            }
        }
        .navigationTitle("Dashboards")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateToGames = true
                }) {
                    Image("Button")
                        .resizable()
                        .frame(width: 32, height: 48)
                }
                .navigationDestination(isPresented: $navigateToGames) {
                    MainAppView()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isLoggedIn = false
                }) {
                    Image(systemName: "power.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
    }
}

struct LargeButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: backgroundColor.opacity(0.5), radius: 5, x: 0, y: 5)
    }
}
