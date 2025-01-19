//
//  RegisterScreen.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 12/10/2024.
//

import SwiftUI

struct RegisterScreen: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var sailboatType: String = ""
    
    @Binding var loginState: LoginState
    
    init(loginState: Binding<LoginState>) {
        _loginState = loginState
    }
    
    private func register() {
        Task {
            guard let token: Token = await AuthService.shared.getToken() else { return }
            guard let email: String = token.email else { return }
            
            let profile: ProfileCreateModel = ProfileCreateModel(firstName: firstName, lastName: lastName, email: email, sailboatType: sailboatType)
            let success = await ProfileService.shared.register(profile)
            
            if success {
                loginState = .loggedIn
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField(text: $firstName, label: { Text("First Name") })
                    .textFieldStyle(.roundedBorder)
                TextField(text: $lastName, label: { Text("Last Name") })
                    .textFieldStyle(.roundedBorder)
                TextField(text: $sailboatType, label: { Text("Sailboat Type") })
                    .textFieldStyle(.roundedBorder)
                Button(action: register, label: { Text("Register").padding(.horizontal, 100) })
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                Spacer()
            }
            .padding(20)
            .navigationTitle(Text("Register"))
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state: LoginState = .needsRegistration
            var body: some View {
                RegisterScreen(loginState: $state)
            }
        }

        return Preview()
}
