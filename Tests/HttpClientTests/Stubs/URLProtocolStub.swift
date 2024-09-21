//
//  URLProtocolStub.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/20/24.
//

import Foundation

class URLProtocolStub: URLProtocol {
    public static var request: URLRequest? = nil

    private static var stub: Stub?

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    public static func register() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    public static func unregister() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        request = nil
    }
    
    public static func stub(
        data: Data? = nil,
        response: URLResponse? = nil,
        error: NSError? = nil
    ) {
        stub = Stub(data: data, response: response, error: error)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        self.request = request
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let data = Self.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = Self.stub?.response {
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
        }
        
        if let error = Self.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
