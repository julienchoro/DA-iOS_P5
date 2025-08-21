//
//  MockURLSession.swift
//  AuraTests
//
//  Created by Test on 17/08/25.
//

import Foundation
@testable import Aura


// MARK: - Mock URL Session
class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}
