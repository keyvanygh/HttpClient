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
}
