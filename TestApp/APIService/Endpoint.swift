//
//  Endpoint.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []

    func url(baseURL: URL) -> URL? {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}

extension Endpoint {
  static func listings(query: String? = nil) -> Endpoint {
    Endpoint(
      path: "listings",
      queryItems: query.map { [URLQueryItem(name: "query", value: $0)] } ?? []
    )
  }
  static let categories = Endpoint(path: "categories")
}
