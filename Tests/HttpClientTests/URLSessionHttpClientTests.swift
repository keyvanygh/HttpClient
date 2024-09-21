//
//  URLSessionHttpClientTests.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import XCTest
import HttpClient

final class URLSessionHttpClientTests: XCTestCase {
    
    func test_get_performGetRequestToURL() async {
        let url: URL = .dummy
        let sut = URLSessionHttpClient()
        URLProtocolStub.stub(error: .anyError)
        
        let expectation = expectation(description: "observe request")
        
        URLProtocolStub.addRequestObserver { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, HttpMethod.GET.rawValue)
            expectation.fulfill()
        }
        
        _ = try? await sut.get(url: url)
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_get_throwsErrorOnRequestError() async {
        let url: URL = .dummy
        let sut = URLSessionHttpClient()
        let anyError: NSError = .anyError
        
        URLProtocolStub.stub(error: anyError)
        
        await expect(sutToThrow: anyError, When: {
            try await sut.get(url: url)
        })
    }
    
    func test_get_throwNotHttpResponseErrorOnRequestWithNotHttpResoponse() async {
        let url: URL = .dummy
        let client = URLSessionHttpClient()
        let anyNotHttpResponse = URLResponse.init(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        URLProtocolStub.stub(response: anyNotHttpResponse)
        
        await expect(sutToThrow: URLSessionHttpClient.Error.notHttpResponse as NSError,  When: {
            try await client.get(url: url)
        })
    }
    
    func test_get_returnCorrectDataAndResponseOnSuccessRequest() async  {
        let url: URL = .dummy
        let data: Data = .dummy
        let response = HTTPURLResponse.ok_200
        let sut = URLSessionHttpClient()
        
        URLProtocolStub.stub(data: data, response: response)
        
        await expect(sutToReturn: (data, response), when: {
            try await sut.get(url: url)
        })
    }
    
    func test_post_performPostRequestToURLWithBody() async {
        let url: URL = .dummy
        let sut = URLSessionHttpClient()
        let bodyData: Data = .dummy
        URLProtocolStub.stub(error: .anyError)
        
        let expecation = expectation(description: "observe request")
        
        URLProtocolStub.addRequestObserver { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, HttpMethod.POST.rawValue)
            XCTAssertEqual(request.httpBodyStream?.data, bodyData)
            expecation.fulfill()
        }
        
        _ = try? await sut.post(url: url, body: bodyData)
        
        await fulfillment(of: [expecation], timeout: 1)
    }
    
    func test_get_performPostRequestWithPassedHeader() async {
        let url: URL = .dummy
        let sut = URLSessionHttpClient()
        let bodyData: Data = .dummy
        let anyHeader: [String: String] = .dummy
        URLProtocolStub.stub(error: .anyError)
        
        let expecation = expectation(description: "observe request")
        
        URLProtocolStub.addRequestObserver { request in
            guard let requestHeader = request.allHTTPHeaderFields else {
                return XCTFail("expeced header but received nil")
            }
            XCTAssertTrue(anyHeader.isSubset(of: requestHeader), "expected \(anyHeader), but received \(requestHeader)")

            expecation.fulfill()
        }
        
        _ = try? await sut.post(url: url, body: bodyData, header: anyHeader)
        
        await fulfillment(of: [expecation], timeout: 1)
    }
    
    func test_post_throwsErrorOnRequestError() async {
        let url: URL = .dummy
        let sut = URLSessionHttpClient()
        let anyError: NSError = .anyError
        
        URLProtocolStub.stub(error: anyError)
        
        await expect(sutToThrow: anyError, When: {
            try await sut.post(url: url)
        })
    }
    
    func test_post_throwNotHttpResponseErrorOnRequestWithNotHttpResoponse() async {
        let url: URL = .dummy
        let client = URLSessionHttpClient()
        let anyNotHttpResponse = URLResponse.init(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        URLProtocolStub.stub(response: anyNotHttpResponse)
        
        await expect(sutToThrow: URLSessionHttpClient.Error.notHttpResponse as NSError,  When: {
            try await client.get(url: url)
        })
    }
    
    func test_post_returnCorrectDataAndResponseOnSuccessRequest() async  {
        let url: URL = .dummy
        let data: Data = .dummy
        let response = HTTPURLResponse.ok_200
        let sut = URLSessionHttpClient()
        
        URLProtocolStub.stub(data: data, response: response)
        
        await expect(sutToReturn: (data, response), when: {
            try await sut.post(url: url)
        })
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
    
    override func invokeTest() {
        URLProtocolStub.register()
        super.invokeTest()
        URLProtocolStub.unregister()
    }
}
