//
//  ProfileViewState.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 23/12/2024.
//

import Foundation

class ProfileViewState: ObservableObject {
    @Published var profile: Profile?
    @Published var posts: [Post]?
    
    init() {
        Task.detached {
            self.profile = try? await ProfileRepository.shared.fetchProfile()
            self.posts = try? await PostRepository.shared.getAllPosts()
        }
    }
    
    public func refreshPosts() {
        Task.detached {
            self.posts = try? await PostRepository.shared.getAllPosts()
        }
    }
}
