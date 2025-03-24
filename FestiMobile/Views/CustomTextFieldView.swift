//
//  CustomTextFieldView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 21/03/2025.
//
import SwiftUI

struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    var icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .autocapitalization(.none)
        }
        .padding(.horizontal)
    }
}
