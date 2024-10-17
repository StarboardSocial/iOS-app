//
//  AuthService.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 10/10/2024.
//

import Foundation
import _AuthenticationServices_SwiftUI
import Alamofire

class AuthService {
    public static let shared = AuthService()
    
    private let oauthBaseUrl: String = "https://auth.starboardsocial.nl"
    private let callbackDomain: String = "nl.starboardsocial.app"
    
    private init(){}
    
    public func instantiateOAuthFlow(webAuthenticationSession: WebAuthenticationSession) async -> Bool {
        do {
            let clientId: String = try! Configuration.value(for: "OAUTH_CLIENT_ID")
            let tenantId: String = try! Configuration.value(for: "OAUTH_TENANT_ID")
            // Perform the authentication and await the result.
            let urlWithToken = try await webAuthenticationSession.authenticate(
                using: URL(string: "\(oauthBaseUrl)/oauth2/authorize?client_id=\(clientId)&tenantId=\(tenantId)&response_type=code&scope=offline_access&redirect_uri=\(callbackDomain):/callback")!,
                callbackURLScheme: callbackDomain
            )
            try await exchangeCodeForToken(url: urlWithToken)
            return true
        } catch {
            // Respond to any authorization errors.
            print("Error info: \(error)")
            return false
        }
    }
    
    private func exchangeCodeForToken(url: URL) async throws {
        let code: String = getCodeFromUrl(url: url)!
        let token = try await AuthRepository.shared.exchangeCode(code)
        
        saveToken(token: token)
    }
    
    private func refreshToken(_ token: Token) async -> Token? {
        guard let refreshedToken: Token =
                try? await AuthRepository.shared.refreshToken(accessToken: token.accessToken, refreshToken: token.refreshToken)
        else {
            return nil
        }
        
        saveToken(token: refreshedToken)
        return refreshedToken
        
    }
    
    private func getCodeFromUrl(url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }
          
        for item in queryItems {
            if item.name == "code" {
                return item.value
            }
        }
          
          return nil
    }
    
    private func saveToken(token: Token) {
        UserDefaults().set(token.accessToken, forKey: "accessToken")
        UserDefaults().set(token.refreshToken, forKey: "refreshToken")
        UserDefaults().set(token.expiresAt, forKey: "expiresAt")
        UserDefaults().set(token.userId, forKey: "userId")
        
        UserDefaults().synchronize()
    }
    
    public func getToken(forceRefresh: Bool = false) async -> Token? {
        
        guard let accessToken: String = UserDefaults().string(forKey: "accessToken") else { return nil }
        guard let refreshToken: String = UserDefaults().string(forKey: "refreshToken") else { return nil }
        let expiresAt: Int = UserDefaults().integer(forKey: "expiresAt")
        guard let userId: String = UserDefaults().string(forKey: "userId") else { return nil }
        
        let token: Token = Token(accessToken: accessToken, expiresAt: expiresAt, refreshToken: refreshToken, userId: userId)
        if (token.isExpired() || forceRefresh) {
            let refreshedToken: Token? = await self.refreshToken(token)
            return refreshedToken
        }
        return token
    }
}
