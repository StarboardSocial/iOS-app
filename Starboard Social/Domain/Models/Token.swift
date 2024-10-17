//
//  Token.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

import Foundation
import JWTDecode

struct Token: Codable {
    
    let accessToken: String
    let expiresAt: Int
    let refreshToken: String
    let userId: String
    
    var email: String? {
        do {
            let jwt = try decode(jwt: accessToken)
            return jwt["email"].string
        } catch {
            return nil
        }
    }
    
    public func isExpired() -> Bool {
        return expiresAt < Int(Date.now.timeIntervalSince1970)
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case userId = "userId"
    }
}
