//
//  HttpClient.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = (data: Data, response: HTTPURLResponse)
    
    func request(to url: URL, httpMethod: HttpMethod, header: [String:String]?, body: Data?) async throws -> Result
}

public enum HttpMethod: String, CaseIterable {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
}

