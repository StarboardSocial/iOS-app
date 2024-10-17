//
//  ProfileService.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

class ProfileService {
    public static let shared = ProfileService()
    
    private init() {}
    
    public func getProfile() async throws -> Profile {
        return try await ProfileRepository.shared.fetchProfile()
    }
    
    public func register(_ profile: ProfileCreateModel) async -> Bool {
        return await ProfileRepository.shared.register(profile)
    }
}
