//
//  AuthInterceptor.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 11/10/2024.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    private let token: Token
    
    public init(_ _token: Token) {
        self.token = _token
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: token.accessToken))

        completion(.success(urlRequest))
    }
    
    
}
