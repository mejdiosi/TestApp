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
  
  
  func testEmptySearchLoadsTheFullFeed() async {
    let service = MockAPIService()
    let viewModel = makeViewModel(service: service)
    viewModel.searchText = "   "
    
    await viewModel.search()
    
    XCTAssertEqual(service.requestedQueries, [nil])
  }
  
  func testCancelledSearchDoesNotChangeTheState() async {
    let service = MockAPIService(listings: [listing(id: 1, categoryID: 10)], delay: .seconds(5))
    let viewModel = makeViewModel(service: service)
    
    let task = Task { await viewModel.search() }
    task.cancel()
    await task.value
    
    XCTAssertEqual(viewModel.state, .loading)   // not .failed, no stale items
    XCTAssertTrue(viewModel.filteredItems.isEmpty)
  }
  
  func testListingsEndpointEncodesTheSearchQuery() {
    let url = Endpoint.listings(query: "vélo bleu").url(baseURL: URL(string: "https://example.com")!)
    
    XCTAssertEqual(url?.absoluteString, "https://example.com/listings?query=v%C3%A9lo%20bleu")
  }

    // MARK: - Helpers

    private func makeViewModel(service: MockAPIService) -> ListingListViewModel {
      ListingListViewModel(service: service, baseURL: URL(string: "https://example.com")!, searchDebounce: .zero)
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

private final class MockAPIService: APIServiceProtocol {
  var listings: [Listing]
  var categories: [ListingCategory]
  var listingsError: Error?
  var delay: Duration?
  private(set) var requestedQueries: [String?] = []
  
  init(listings: [Listing] = [], categories: [ListingCategory] = [],
       listingsError: Error? = nil, delay: Duration? = nil) {
    self.listings = listings
    self.categories = categories
    self.listingsError = listingsError
    self.delay = delay
  }
  
  func fetchListings(query: String?) async throws -> [Listing] {
    requestedQueries.append(query)
    if let delay { try await Task.sleep(for: delay) }
    if let listingsError { throw listingsError }
    return listings
  }
  
  func fetchCategories() async throws -> [ListingCategory] { categories }
}

private enum TestError: LocalizedError {
    case unavailable

    var errorDescription: String? { "Service unavailable" }
}
