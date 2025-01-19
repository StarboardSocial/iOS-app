//
//  ProfileScreen.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 23/12/2024.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject private var state: ProfileViewState
    
    init() {
        state = .init()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Circle()
                        .fill((Color.gray))
                        .frame(width: 64)
                        .aspectRatio(1, contentMode: .fit)
                    
                    Spacer().frame(width: 30)
                    
                    VStack(alignment: .leading) {
                        Text("\(state.profile?.firstName ?? "ERROR") \(state.profile?.lastName ?? "ERROR")")
                        Text("Owner of a \(state.profile?.sailboatType ?? "ERROR")")
                            .font(.footnote)
                    }
                    
                }
                .padding(.vertical, 20)
                
                if (state.posts != nil && !state.posts!.isEmpty) {
                    ScrollView {
                        ForEach(state.posts!) { post in
                            PostWidget(post)
                        }
                    }
                    .refreshable {
                        state.refreshPosts()
                    }
                } else {
                    Text("You have no posts yet")
                    Button(action: {
                        Task {
                            state.refreshPosts()
                        }
                    }) {
                        Text("Refresh")
                            .padding(.horizontal, 100)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
                
                Spacer()
                Button(action: {
                    Task {
                        try? await AuthService.shared.revokeToken()
                    }
                }) {
                    Text("Logout")
                        .padding(.horizontal, 100)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .navigationBarTitle("Profile")
        }
    }
}

#Preview {
    ProfileScreen()
}
