//
//  URLSessionHttpClient.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import Foundation

public class URLSessionHttpClient: HTTPClient {
    let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public enum Error: Swift.Error {
        case notHttpResponse
    }
    
    public func get(url: URL, header: [String: String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(url: url, header: header)
        
        let (data, response) =  try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }
        
        return (data, httpResponse)
    } 
    
    public func post(url: URL, body: Data? = nil, header: [String: String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(
            url: url,
            httpMethod: .POST,
            body: body,
            header: header
        )
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    public func put(url: URL, body: Data? = nil, header: [String : String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(
            url: url,
            httpMethod: .PUT,
            body: body,
            header: header
        )
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    public func patch(url: URL, body: Data? = nil, header: [String : String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(
            url: url,
            httpMethod: .PATCH,
            body: body,
            header: header
        )
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    public func delete(url: URL, body: Data? = nil, header: [String : String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(
            url: url,
            httpMethod: .DELETE,
            body: body,
            header: header
        )
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    public func head(url: URL, header: [String : String]? = nil) async throws -> HTTPClient.Result {
        let request = makeRequest(
            url: url,
            httpMethod: .HEAD,
            header: header
        )
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    // MARK: - Helpers
    
    private func makeRequest(
        url: URL,
        httpMethod: HttpMethod = .GET,
        body: Data? = nil,
        header: [String: String]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue
        
        if let body {
            request.httpBody = body
        }
        
        if let header {
            request.allHTTPHeaderFields = request.allHTTPHeaderFields?.merging(header, uniquingKeysWith: { (_, new) in new })
        }
        
        return request
    }
}
