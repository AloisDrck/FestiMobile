//
//  AddSessionView.swift
//  FestiMobile
//
//  Created by Aloïs Drucké on 19/03/2025.
//

import SwiftUI

struct AddSessionView: View {
    @ObservedObject var viewModel: SessionViewModel
    @State private var dateDebut = Date()
    @State private var dateFin = Date()
    @State private var fraisDepot = ""
    @State private var commission = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ajouter une session")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            inputField(title: "Date de début", date: $dateDebut)
            inputField(title: "Date de fin", date: $dateFin)
            inputField(title: "Frais de dépôt (%)", text: $fraisDepot, keyboard: .decimalPad)
            inputField(title: "Commission (%)", text: $commission, keyboard: .decimalPad)
            
            if !alertMessage.isEmpty {
                Text(alertMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top)
            }
            
            Button(action: addSession) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("Ajouter la session")
                        .fontWeight(.bold)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Nouvelle session")
        .background(
            Image("popupBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erreur"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func inputField(title: String, text: Binding<String>? = nil, date: Binding<Date>? = nil, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            if let text = text {
                TextField(title, text: text)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .keyboardType(keyboard)
            } else if let date = date {
                DatePicker(title, selection: date, displayedComponents: .date)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    
    private func addSession() {
        guard let frais = Double(fraisDepot), let commissionValue = Double(commission) else {
            alertMessage = "Veuillez entrer des valeurs valides pour les frais de dépôt et la commission."
            showAlert = true
            return
        }

        let newSession = Session(id: nil, dateDebut: dateDebut, dateFin: dateFin, fraisDepot: frais, commission: commissionValue, statutSession: "Planifiée")

        viewModel.addSession(newSession) { success, errorMessage in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else if let message = errorMessage {
                alertMessage = message
                showAlert = true
            }
        }
    }
}
