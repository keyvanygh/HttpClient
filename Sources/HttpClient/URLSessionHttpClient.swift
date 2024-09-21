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
    
    public func get(url: URL) async throws -> HTTPClient.Result {
        let request = URLRequest(url: url)
        
        let (data, response) =  try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }
        
        return (data, httpResponse)
    } 
    
    public func post(url: URL, body: Data? = nil, header: [String: String]? = nil) async throws -> HTTPClient.Result {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = body
        if let header {
        request.allHTTPHeaderFields = request.allHTTPHeaderFields?.merging(header, uniquingKeysWith: { (_, new) in new })
        }
        
        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
}
