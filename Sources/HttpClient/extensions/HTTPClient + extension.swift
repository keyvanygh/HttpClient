//
//  HTTPClient + extension.swift
//
//
//  Created by Keyvan Yaghoubian on 9/21/24.
//

import Foundation

public extension HTTPClient {
    func request(
        _ httpMethod: HttpClient.HttpMethod,
        to url: URL,
        header: [String : String]? = nil,
        body: Data? = nil
    ) async throws -> HTTPClient.Result {
        try await request(httpMethod, to: url, header: header, body: body)
    }
}
