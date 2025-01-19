//
//  AuthRequest.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 16/10/2024.
//

import Foundation
import Alamofire

enum PostRequest: URLRequestConvertible {
    case getAll
    case create(PostCreateModel)
    case feed(Int)
    
    var path: String {
        switch self {
            case .getAll: return "/post/private/all"
            case .create: return "/post/private"
            case .feed(let page): return "/post/public/feed?page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getAll: return .get
            case .create: return .post
            case .feed: return .get
        }
    }
    
    var body: Data? {
        switch self {
            case .create(let model): return try? JSONEncoder().encode(model)
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
