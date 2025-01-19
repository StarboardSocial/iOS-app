//
//  ProfileViewState.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 23/12/2024.
//

import Foundation

class FeedViewState: ObservableObject {
    @Published var posts: [Post]?
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 0
    
    @MainActor init() {
        Task {
            self.posts = try? await PostRepository.shared.getFeed(page: self.currentPage)
        }
    }
    
    @MainActor public func refreshPosts() {
        Task {
            self.currentPage = 0
            self.posts = try? await PostRepository.shared.getFeed(page: self.currentPage)
        }
    }
    
    @MainActor public func loadNextPage() async {
        isLoading = true
        currentPage += 1
        posts?.append(contentsOf: try! await PostRepository.shared.getFeed(page: currentPage))
        isLoading = false
    }
}
