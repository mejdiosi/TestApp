//
//  ListingDecodingTests.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 30/9/2026.
//


import XCTest
@testable import TestApp

final class ListingDecodingTests: XCTestCase {
    func testDecodesAListingWithAllFields() throws {
        let json = """
        {
          "id": 42,
          "category_id": 4,
          "title": "Statue",
          "description": "Nice statue",
          "price": 140.5,
          "creation_date": "2019-11-05T15:56:59Z",
          "is_urgent": true,
          "images_url": { "small": "/images/small/a.jpg", "thumb": "/images/thumb/a.jpg" }
        }
        """

        let listing = try JSONDecoder.api.decode(Listing.self, from: Data(json.utf8))

        XCTAssertEqual(listing.id, 42)
        XCTAssertEqual(listing.categoryId, 4)
        XCTAssertEqual(listing.title, "Statue")
        XCTAssertEqual(listing.price, 140.5)
        XCTAssertTrue(listing.isUrgent)
        // 2019-11-05T15:56:59Z
        XCTAssertEqual(listing.creationDate, Date(timeIntervalSince1970: 1_572_969_419))
        XCTAssertEqual(
            listing.imagesUrl,
            ImagesURL(small: "/images/small/a.jpg", thumb: "/images/thumb/a.jpg")
        )
    }

    func testDecodesTheFeedEvenWhenImagesAreMissing() throws {
        let json = """
        {
          "total": 2,
          "page": 1,
          "limit": 20,
          "has_more": false,
          "items": [
            \(listingJSON(id: 1, images: "null")),
            \(listingJSON(id: 2, images: #"{ "small": null, "thumb": null }"#))
          ]
        }
        """

        let feed = try JSONDecoder.api.decode(ListingFeed.self, from: Data(json.utf8))

        XCTAssertEqual(feed.total, 2)
        XCTAssertFalse(feed.hasMore)
        XCTAssertEqual(feed.items.map(\.id), [1, 2])
        XCTAssertNil(feed.items[0].imagesUrl)
        XCTAssertEqual(feed.items[1].imagesUrl, ImagesURL(small: nil, thumb: nil))
    }

    // MARK: - Helpers

    private func listingJSON(id: Int, images: String) -> String {
        """
        {
          "id": \(id), "category_id": 1, "title": "Title", "description": "Description",
          "price": 1.0, "creation_date": "2020-01-01T10:00:00Z", "is_urgent": false,
          "images_url": \(images)
        }
        """
    }
}
