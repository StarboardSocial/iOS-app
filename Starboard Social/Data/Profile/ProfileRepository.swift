//
//  ProfileRepository.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

import Foundation

class ProfileRepository {
    public static let shared = ProfileRepository()
    
    private init(){}
    
    func fetchProfile() async throws -> Profile {
        let request = ProfileRequest.getProfile
        let result = await Api.shared.request(request, type: Profile.self)
        return try result.get()
    }
    
    public func register(_ profile: ProfileCreateModel) async -> Bool {
        let request = ProfileRequest.register(profile)
        let result = await Api.shared.request(request)
        return result?.statusCode ?? 401 == 200
    }
}
