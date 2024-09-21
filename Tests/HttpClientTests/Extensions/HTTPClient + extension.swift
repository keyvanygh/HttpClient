//
//  HTTPClient + extension.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/21/24.
//

import Foundation
import HttpClient


extension HTTPClient {
    public func performRequest(
        withHttpMethod method: HttpMethod,
        to url: URL,
        withHeader header: [String:String]? = nil,
        andBody body: Data? = nil
    ) async throws -> HTTPClient.Result {
        try await request(to: url, httpMethod: method, header: header, body: body)
    }
}

extension HttpMethod {
    var canHaveBody: Bool {
        return self != .GET && self != .HEAD
    }
}
