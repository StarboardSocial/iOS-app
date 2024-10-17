//
//  ProfileRequest.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

import Foundation
import Alamofire

enum ProfileRequest: URLRequestConvertible {
    case getProfile
    case register(ProfileCreateModel)
    
    var path: String {
        switch self {
            case .getProfile: return "/user/profile"
            case .register: return "/user/registration"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getProfile: return .get
            case .register: return .post
        }
    }
    
    var body: Data? {
        switch self {
            case .register(let model): return try? JSONEncoder().encode(model)
            default: return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let scheme: String = try! Configuration.value(for: "API_BASE_SCHEME")
        let baseUrl: String = try! Configuration.value(for: "API_BASE_URL")
        let url: URL = .init(string: "\(scheme)://\(baseUrl)\(path)")!
        var request: URLRequest = .init(url: url)
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = body
        return request
    }
}
