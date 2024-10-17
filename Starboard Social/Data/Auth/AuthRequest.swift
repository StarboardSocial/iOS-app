//
//  AuthRequest.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 16/10/2024.
//

import Foundation
import Alamofire

enum AuthRequest: URLRequestConvertible {
    case exchangeCode(code: String)
    case refreshToken(accessToken: String, refreshToken: String)
    
    var path: String {
        switch self {
            case .exchangeCode(let code): return "/auth/token/exchange?code=\(code)&redirectUri=nl.starboardsocial.app:/callback"
            case .refreshToken: return "/auth/token/refresh"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: HTTPHeaders {
        switch self {
            case .refreshToken(let accessToken, let refreshToken):
                return .init(["AccessToken": accessToken, "RefreshToken": refreshToken])
            default : return .init([:])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let scheme: String = try! Configuration.value(for: "API_BASE_SCHEME")
        let baseUrl: String = try! Configuration.value(for: "API_BASE_URL")
        let url: URL = .init(string: "\(scheme)://\(baseUrl)\(path)")!
        var request: URLRequest = .init(url: url)
        request.method = method
        request.headers = headers
        return request
    }
    
    
}
