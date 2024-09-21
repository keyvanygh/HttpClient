//
//  HttpClient.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = (data: Data, response: HTTPURLResponse)
    
    func get(url: URL, header: [String: String]?) async throws -> Result
    func post(url: URL, body: Data?, header: [String: String]?) async throws -> Result
    func put(url: URL, body: Data?, header: [String: String]?) async throws -> Result
    func patch(url: URL, body: Data?, header: [String: String]?) async throws -> Result
    func delete(url: URL, body: Data?, header: [String: String]?) async throws -> Result
    func head(url: URL, header: [String: String]?) async throws -> Result
}

public enum HttpMethod: String, CaseIterable {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
}

