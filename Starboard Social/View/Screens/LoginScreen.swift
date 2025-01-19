//
//  LoginScreen.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 10/10/2024.
//

import SwiftUI

struct LoginScreen: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    private let authService: AuthService = AuthService.shared
    @Binding private var loginState: LoginState
    
    init(_loginState: Binding<LoginState>) {
        self._loginState = _loginState
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Starboard Social")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("The platform for sailors")
            Spacer()
            Spacer()
            Button(action: {
                Task {
                    loginState = .loading
                    let success: Bool = await authService.instantiateOAuthFlow(webAuthenticationSession: webAuthenticationSession)
                    if (success) {
                        NotificationCenter.default.post(name: NSNotification.Name("auth_state_changed"), object: nil)
                    } else {
                        loginState = .loggedOut
                    }
                }
            }) {
                Text("Login")
                    .padding(.horizontal, 100)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            Spacer()
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state: LoginState = .loggedOut
            var body: some View {
                LoginScreen(_loginState: $state)
            }
        }

        return Preview()
}
