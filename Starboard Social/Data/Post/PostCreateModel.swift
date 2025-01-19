//
//  PostCreateModel.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 24/12/2024.
//

import Foundation

struct PostCreateModel: Codable {
    let title: String
    let description: String?
    let imageBase64: String
    let imageExtension: String
}
