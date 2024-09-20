//
//  HttpClient.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = (data: Data, response: HTTPURLResponse)
    
    func get(url: URL) async throws -> Result
    func post(url: URL, body: Data?) async throws -> Result
}

extension HTTPURLResponse {
    var isOk_200: Bool {
        return statusCode == 200
    }
}
