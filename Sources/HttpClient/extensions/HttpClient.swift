//
//  HttpClient.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = (data: Data, response: HTTPURLResponse)
    
    func get(url: URL) async throws -> Result
    func post(url: URL, body: Data?, header: [String: String]?) async throws -> Result
}

public enum HttpMethod: String {
    case GET
    case POST
}

