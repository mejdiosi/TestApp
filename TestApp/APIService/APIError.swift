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
            return "Impossible de joindre le serveur. Vérifiez votre connexion et réessayez."
        case .invalidURL, .invalidResponse, .badStatus, .decoding:
            return "Une erreur est survenue. Veuillez réessayer."
        }
    }
}
