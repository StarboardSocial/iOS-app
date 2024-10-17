//
//  Api.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

import Alamofire
import Foundation

class Api {
    public static var shared = Api()
    
    private init() {}
    
    private let baseUrl: String = try! Configuration.value(for: "API_BASE_URL")
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    func request<T: Codable>(_ request: URLRequestConvertible, type: T.Type, skipAuth: Bool = false) async -> Result<T, AFError> {
        debugPrint("Sending request to \(request.urlRequest?.url?.absoluteString ?? "Unknown URL")")
        if (skipAuth) {
            return await AF.request(request).validate().serializingDecodable(type, decoder: decoder).result
        }
        guard let token: Token = await AuthService.shared.getToken() else { return .failure(.explicitlyCancelled) }
        return await AF.request(request, interceptor: AuthInterceptor(token)).validate().serializingDecodable(type, decoder: decoder).result
    }
    
    func request(_ request: URLRequestConvertible, skipAuth: Bool = false) async -> HTTPURLResponse? {
        debugPrint("Sending request to \(request.urlRequest?.url?.absoluteString ?? "Unknown URL")")
        guard let token: Token = await AuthService.shared.getToken() else { return nil }
        if (skipAuth) {
            return await withCheckedContinuation { continuation in
                AF.request(request).validate().response { response in
                    debugPrint("Received response: \(String(describing: response.response))")
                    continuation.resume(returning: response.response)
                    return
                }
            }
        }
        return await withCheckedContinuation { continuation in
            AF.request(request, interceptor: AuthInterceptor(token)).validate().response { response in
                debugPrint("Received response: \(String(describing: response.response))")
                continuation.resume(returning: response.response)
                return
            }
        }
    }
}
