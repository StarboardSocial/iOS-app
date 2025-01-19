//
//  AuthRepository.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 16/10/2024.
//

import Foundation

class AuthRepository {
    public static let shared = AuthRepository()
    
    private init(){}
    
    public func exchangeCode(_ code: String) async throws -> Token {
        let request = AuthRequest.exchangeCode(code: code)
        let result = await Api.shared.request(request, type: Token.self, skipAuth: true)
        return try result.get()
    }
    
    public func refreshToken(accessToken: String, refreshToken: String) async throws -> Token {
        let request = AuthRequest.refreshToken(accessToken: accessToken, refreshToken: refreshToken)
        let result = await Api.shared.request(request, type: Token.self, skipAuth: true)
        return try result.get()
    }
    
    public func revokeToken() async throws {
        let request = AuthRequest.revokeToken
        _ = await Api.shared.request(request, skipAuth: false)
        return
    }
}
