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
        switch method {
        case .GET:
            return try await self.get(url: url, header: header)
        case .POST:
            return try await self.post(url: url, body: body, header: header)
        case .PUT:
            return try await self.put(url: url, body: body, header: header)
        case .PATCH:
            return try await self.patch(url: url, body: body, header: header)
        case .DELETE:
            return try await self.delete(url: url, body: body, header: header)
        case .HEAD:
            return try await self.head(url: url, header: header)
        }
    }
}

extension HttpMethod {
    var canHaveBody: Bool {
        return self != .GET && self != .HEAD
    }
}
