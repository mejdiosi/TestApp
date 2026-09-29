//
//  JSONDecoder.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

extension JSONDecoder {
    /// ISO 8601 dates
  static var api: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }
}
