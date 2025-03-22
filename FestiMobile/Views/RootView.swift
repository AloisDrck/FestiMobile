//
//  RootView.swift
//  FestiMobile
//
//  Created by Zolan Givre on 22/03/2025.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                AdminView()
            } else {
                HomeView()
            }
        }
    }
}
