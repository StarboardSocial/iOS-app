//
//  Starboard_SocialApp.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 26/09/2024.
//

import SwiftUI

@main
struct Starboard_SocialApp: App {
    @State var loginState: LoginState = .loading
    
    private func checkLoginState() async {
        if (await AuthService.shared.getToken(forceRefresh: true) == nil) {
            loginState = .loggedOut
            return
        }
        guard let _: Profile = try? await ProfileService.shared.getProfile() else {
            loginState = .needsRegistration
            return
        }
        
        loginState = .loggedIn
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                switch loginState {
                case .loggedOut:
                    LoginScreen(_loginState: $loginState)
                case .needsRegistration:
                    RegisterScreen(loginState: $loginState)
                case .loading:
                    VStack {
                        ProgressView()
                            .tint(.accentColor)
                        Text("Loading Starboard Social")
                    }
                case .loggedIn:
                    TabView {
                        ContentView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        ContentView()
                            .tabItem {
                                Label("Recommendations", systemImage: "star")
                            }
                        ContentView()
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                    }
                }
            }.onAppear {
                Task {
                    await checkLoginState()
                }
            }
            
        }
    }
}
