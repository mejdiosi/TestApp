//
//  APIServiceProtocol.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

protocol APIServiceProtocol {
    func fetchListings(query: String?) async throws -> [Listing]
    func fetchCategories() async throws -> [Category]
}

struct APIService: APIServiceProtocol {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

  func fetchListings(query: String?) async throws -> [Listing] {
    try await fetch(.listings(query: query), as: ListingFeed.self).items
  }

    func fetchCategories() async throws -> [Category] {
        try await fetch(.categories, as: [Category].self)
    }

    private func fetch<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        guard let url = endpoint.url(baseURL: baseURL) else { throw APIError.invalidURL }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode) }

        do {
            return try JSONDecoder.api.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
