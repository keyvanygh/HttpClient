//
//  URLSessionHttpClientTests.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import XCTest
import HttpClient

final class URLSessionHttpClientTests: XCTestCase {
    
    func test_request_performRequestWithExpectedRequest() async {
        for method in HttpMethod.allCases {
            let url: URL = .dummy
            let body: Data = .dummy
            let header: [String: String] = .dummy
            let sut = makeSUT()
            
            URLProtocolStub.stub(error: .dummy)
            
            _ = try? await sut.request(
                method,
                to: url,
                header: header,
                body: body
            )
                        
            expect(
                request: URLProtocolStub.request!,
                withMethod: method,
                url: url,
                header: header,
                body: body
            )
        }
    }
    
    func test_request_throwsErrorOnRequestError() async {
        for method in HttpMethod.allCases {
            let url: URL = .dummy
            let sut = makeSUT()
            let anyError: NSError = .dummy
            
            URLProtocolStub.stub(error: anyError)
            
            await expect(sutToThrow: anyError, When: {
                try await sut.request(method, to: url)
            })
        }
    }
    
    func test_request_throwNotHttpResponseErrorOnRequestWithNotHttpResoponse() async {
        for method in HttpMethod.allCases {
            let url: URL = .dummy
            let sut = makeSUT()
            let anyNotHttpResponse = URLResponse.init(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            
            URLProtocolStub.stub(response: anyNotHttpResponse)
            
            await expect(sutToThrow: URLSessionHttpClient.Error.notHttpResponse as NSError,  When: {
                try await sut.request(method, to: url)
            })
        }
    }
    
    func test_request_returnCorrectDataAndResponseOnSuccessRequest() async  {
        for method in HttpMethod.allCases {
            let url: URL = .dummy
            let data: Data = .dummy
            let response = HTTPURLResponse.ok_200
            let sut = makeSUT()
            
            URLProtocolStub.stub(data: data, response: response)
            
            await expect(sutToReturn: (data, response), when: {
                try await sut.request(method, to: url)
            })
        }
    }
    
    private func expect(sutToReturn expectedReturn: HTTPClient.Result, when: @escaping () async throws -> (HTTPClient.Result)) async {
        do {
            let result = try await when()
            XCTAssertEqual(expectedReturn.data, result.data)
            XCTAssertEqual(expectedReturn.response.statusCode, result.response.statusCode)
        } catch {
            XCTFail("client should have returned data but throws \(error) instead")
        }
    }
    
    private func expect(sutToThrow expectedError: NSError, When when: @escaping () async throws -> (HTTPClient.Result)) async {
        do {
            let result = try await when()
            XCTFail("client should have thrown error but returned \(result) instead")
        } catch {
            let receivedError = error as NSError
            XCTAssertEqual(receivedError.domain, expectedError.domain)
            XCTAssertEqual(receivedError.code, expectedError.code)
            XCTAssertEqual(receivedError.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    private func makeSUT() -> URLSessionHttpClient {
        return URLSessionHttpClient()
    }
    
    private func expect(
        request: URLRequest,
        withMethod method: HttpMethod,
        url: URL,
        header: [String:String]? = nil,
        body: Data? = nil
    ) {
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, method.rawValue)
        
        if let header {
            let requestHeader = request.allHTTPHeaderFields ?? [:]
            XCTAssertTrue(header.isSubset(of: requestHeader), "expected \(header), but received \(requestHeader)")
        }
        
        if method.canHaveBody {
            XCTAssertEqual(request.httpBodyStream?.data, body)
        }
    }
    
    override func invokeTest() {
        URLProtocolStub.register()
        super.invokeTest()
        URLProtocolStub.unregister()
    }
}
