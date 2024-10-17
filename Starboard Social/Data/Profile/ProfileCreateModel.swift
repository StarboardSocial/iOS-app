//
//  ProfileCreateModel.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 12/10/2024.
//

import Foundation

struct ProfileCreateModel: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let sailboatType: String?
}
