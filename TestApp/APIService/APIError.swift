//
//  APIError.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatus(Int)
    case decoding(Error)
    case transport(Error)

    /// Message safe to show to the user.
    var errorDescription: String? {
        switch self {
        case .transport:
            return "Unable to reach the server. Check your connection and try again."
        case .invalidURL, .invalidResponse, .badStatus, .decoding:
            return "Something went wrong. Please try again."
        }
    }
}