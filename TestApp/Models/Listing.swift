//
//  Listing.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//

import Foundation

struct Listing: Decodable, Identifiable, Equatable {
  let id: Int
  let categoryId: Int
  let title: String
  let description: String
  let price: Double
  let creationDate: Date
  let isUrgent: Bool
    /// The API may return `null`, or null values inside, so both levels are optional.
  let imagesUrl: ImagesURL?
}

struct ImagesURL: Decodable, Equatable {
  let small: String?
  let thumb: String?
}
