//
//  ListingFeed.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation

/// Envelope returned by `GET /listings`.
struct ListingFeed: Decodable, Equatable {
    let total: Int
    let page: Int
    let limit: Int
    let hasMore: Bool
    let items: [Listing]
}