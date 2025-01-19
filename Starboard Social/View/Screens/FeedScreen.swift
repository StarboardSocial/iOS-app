//
//  FeedScreen.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 24/12/2024.
//

import SwiftUI

struct FeedScreen: View {
    @ObservedObject private var state: FeedViewState
    
    init() {
        state = .init()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (state.posts != nil && !state.posts!.isEmpty) {
                    postList
                    .refreshable {
                        state.refreshPosts()
                    }
                } else {
                    Text("There are no posts in your feed :(")
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
            }
            .navigationTitle(Text("Feed"))
        }
    }
    
    var postList: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach((0..<(state.posts!.count)), id: \.self) { i in
                    let post: Post = state.posts![i]
                    
                    PostWidget(post)
                        .onAppear {
                            Task {
                                if (i > state.posts!.count - 2 && !state.isLoading) {
                                    await state.loadNextPage()
                                }
                            }
                        }
                        .padding(.vertical, 15)
                }
            }
        }
        .refreshable {
            state.refreshPosts()
        }
    }
}

#Preview {
    FeedScreen()
}
