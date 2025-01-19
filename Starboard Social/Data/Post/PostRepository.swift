//
//  AuthRepository.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 16/10/2024.
//

import Foundation

class PostRepository {
    public static let shared = PostRepository()
    
    private init(){}
    
    func getAllPosts() async throws -> [Post] {
        let request = PostRequest.getAll
        let result = await Api.shared.request(request, type: [Post].self)
        return try result.get()
    }
    
    public func createPost(_ post: PostCreateModel) async -> Bool {
        let request = PostRequest.create(post)
        let result = await Api.shared.request(request)
        return result?.statusCode ?? 401 == 200
    }
    
    public func getFeed(page: Int) async throws -> [Post] {
        let request = PostRequest.feed(page)
        let result = await Api.shared.request(request, type: [Post].self)
        return try result.get()
    }
}
