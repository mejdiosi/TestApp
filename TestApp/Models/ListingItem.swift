//
//  ListingItem.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

  /// Display model shared by the list rows and the detail screen.
  /// Combines a `Listing` with its category name and turns raw API values
  /// (relative image paths, `Double` price, `Date`) into what the views show.
struct ListingItem: Identifiable, Equatable {
  let id: Int
  let title: String
  let description: String
  let categoryId: Int
  let categoryName: String
  let formattedPrice: String
  let formattedDate: String
  let isUrgent: Bool
    /// Small image for list rows. `nil` when the listing has no image.
  let thumbnailURL: URL?
    /// Larger image for the detail screen. `nil` when the listing has no image.
  let imageURL: URL?
  
  static let unknownCategoryName = "Autre"
  
  init(listing: Listing, categoryName: String?, baseURL: URL) {
    id = listing.id
    title = listing.title
    description = listing.description
    categoryId = listing.categoryId
    self.categoryName = categoryName ?? Self.unknownCategoryName
    formattedPrice = listing.price.formatted(
      .currency(code: "EUR").precision(.fractionLength(0...2))
    )
    formattedDate = listing.creationDate.formatted(date: .long, time: .shortened)
    isUrgent = listing.isUrgent
    
    let images = listing.imagesUrl
    thumbnailURL = Self.imageURL(from: images?.thumb ?? images?.small, baseURL: baseURL)
    imageURL = Self.imageURL(from: images?.thumb ?? images?.small, baseURL: baseURL)
  }
  
  private static func imageURL(from path: String?, baseURL: URL) -> URL? {
    guard let path, !path.isEmpty else { return nil }
    return URL(string: path, relativeTo: baseURL)?.absoluteURL
  }
}
