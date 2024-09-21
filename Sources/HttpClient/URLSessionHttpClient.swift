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
    
    public func request(
        _ httpMethod: HttpMethod,
        to url: URL,
        header: [String:String]? = nil,
        body: Data? = nil
    ) async throws -> HTTPClient.Result {
        let request = URLRequest(
            url: url,
            httpMethod: httpMethod,
            header: header,
            body: body
        )

        let (data, response) =  try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }

        return (data, httpResponse)
    }
    
    // MARK: - Helpers
    
    private func URLRequest(
        url: URL,
        httpMethod: HttpMethod = .GET,
        header: [String: String]? = nil,
        body: Data? = nil
    ) -> URLRequest {
        var request = Foundation.URLRequest(url: url)

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
