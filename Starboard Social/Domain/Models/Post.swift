//
//  Post.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 23/12/2024.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let userId: String
    let userName: String = "John Doe"
    let title: String
    let description: String
    let image: PostImage?
    let postedAt: Date
}

struct PostImage: Codable {
    let id: String
    let url: String
    
}
