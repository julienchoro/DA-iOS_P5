//
//  URLSessionProtocol.swift
//  Aura
//
//  Created by GitHub Copilot on 21/08/2025.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
