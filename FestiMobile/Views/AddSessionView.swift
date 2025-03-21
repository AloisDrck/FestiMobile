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
        NavigationView {
            Form {
                Section(header: Text("Dates")) {
                    DatePicker("Date de début", selection: $dateDebut, displayedComponents: .date)
                    DatePicker("Date de fin", selection: $dateFin, displayedComponents: .date)
                }
                
                Section(header: Text("Frais de dépôt")) {
                    TextField("Montant en €", text: $fraisDepot)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Commission")) {
                    TextField("Montant en %", text: $commission)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button("Ajouter la session") {
                        addSession()
                    }
                }
            }
            .navigationTitle("Nouvelle session")
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
    }
    
    private func addSession() {
        guard let frais = Double(fraisDepot), let commissionValue = Double(commission) else { return }

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

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSessionView(viewModel: SessionViewModel())
    }
}

