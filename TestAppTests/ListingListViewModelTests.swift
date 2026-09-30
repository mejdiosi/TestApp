//
//  ListingListViewModelTests.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 30/9/2026.
//


import XCTest
@testable import TestApp

private typealias ListingCategory = TestApp.Category

@MainActor
final class ListingListViewModelTests: XCTestCase {
    func testLoadMapsListingsAndCategories() async {
        let service = MockAPIService(
            listings: [listing(id: 1, categoryID: 10)],
            categories: [ListingCategory(id: 10, name: "Vehicles")]
        )
        let viewModel = makeViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.categories, [ListingCategory(id: 10, name: "Vehicles")])
        XCTAssertEqual(viewModel.filteredItems.map(\.categoryName), ["Vehicles"])
    }

    func testFilteredItemsReturnsOnlyTheSelectedCategory() async {
        let service = MockAPIService(
            listings: [listing(id: 1, categoryID: 10), listing(id: 2, categoryID: 20)],
            categories: [ListingCategory(id: 10, name: "Vehicles"), ListingCategory(id: 20, name: "Homes")]
        )
        let viewModel = makeViewModel(service: service)
        await viewModel.load()
        viewModel.selectedCategoryId = 20

        XCTAssertEqual(viewModel.filteredItems.map(\.id), [2])
    }

    func testFilteredItemsPreserveTheOrderReturnedByTheAPI() async {

        let service = MockAPIService(
            listings: [
                listing(id: 3, categoryID: 10),
                listing(id: 1, categoryID: 20),
                listing(id: 2, categoryID: 10)
            ],
            categories: [ListingCategory(id: 10, name: "Vehicles"), ListingCategory(id: 20, name: "Homes")]
        )
        let viewModel = makeViewModel(service: service)
        await viewModel.load()

        XCTAssertEqual(viewModel.filteredItems.map(\.id), [3, 1, 2])

        viewModel.selectedCategoryId = 10

        XCTAssertEqual(viewModel.filteredItems.map(\.id), [3, 2])
    }

    func testLoadExposesAFailureStateWhenTheServiceFails() async {
        let service = MockAPIService(listingsError: TestError.unavailable)
        let viewModel = makeViewModel(service: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed(TestError.unavailable.localizedDescription))
    }

    // MARK: - Helpers

    private func makeViewModel(service: MockAPIService) -> ListingListViewModel {
        ListingListViewModel(service: service, baseURL: URL(string: "https://example.com")!)
    }

    private func listing(id: Int, categoryID: Int, images: ImagesURL? = nil) -> Listing {
        Listing(
            id: id,
            categoryId: categoryID,
            title: "Listing \(id)",
            description: "Description",
            price: 10,
            creationDate: Date(timeIntervalSince1970: 0),
            isUrgent: false,
            imagesUrl: images
        )
    }
}

private struct MockAPIService: APIServiceProtocol {
    var listings: [Listing] = []
    var categories: [ListingCategory] = []
    var listingsError: Error?

    func fetchListings() async throws -> [Listing] {
        if let listingsError { throw listingsError }
        return listings
    }

    func fetchCategories() async throws -> [ListingCategory] {
        categories
    }
}

private enum TestError: LocalizedError {
    case unavailable

    var errorDescription: String? { "Service unavailable" }
}
