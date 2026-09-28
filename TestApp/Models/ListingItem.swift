//
//  ListingItem.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

/// Display model for one row of the list screen.
/// Combines a `Listing` with its category name and turns raw API values
/// (relative image path, `Double` price) into what the view needs.
struct ListingItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let categoryId: Int
    let categoryName: String
    let formattedPrice: String
    let isUrgent: Bool
    /// `nil` when the listing has no image: the view shows a placeholder.
    let thumbnailURL: URL?

    static let unknownCategoryName = "Other"

    init(listing: Listing, categoryName: String?, baseURL: URL) {
        id = listing.id
        title = listing.title
        categoryId = listing.categoryId
        self.categoryName = categoryName ?? Self.unknownCategoryName
        formattedPrice = listing.price.formatted(
            .currency(code: "EUR").precision(.fractionLength(0...2))
        )
        isUrgent = listing.isUrgent
        thumbnailURL = Self.imageURL(from: listing.imagesUrl?.thumb, baseURL: baseURL)
    }

    /// The API returns server-relative paths (e.g. `/images/ad-thumb/x.jpg`).
    private static func imageURL(from path: String?, baseURL: URL) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return URL(string: path, relativeTo: baseURL)?.absoluteURL
    }
}