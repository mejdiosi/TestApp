//
//  ListingListViewModel.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Combine
import Foundation

@MainActor
final class ListingListViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var categories: [Category] = []
    /// `nil` means "All".
    @Published var selectedCategoryId: Int?
    @Published private var items: [ListingItem] = []

    private let service: APIServiceProtocol
    private let baseURL: URL

    init(service: APIServiceProtocol, baseURL: URL) {
        self.service = service
        self.baseURL = baseURL
    }

    /// Items to display for the selected category. The API order is preserved.
    var filteredItems: [ListingItem] {
        guard let selectedCategoryId else { return items }
        return items.filter { $0.categoryId == selectedCategoryId }
    }

    /// Loads once when the screen first appears (not on every reappearance).
    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func load() async {
        let previousState = state
        if state != .loaded { state = .loading }

        do {
            async let listingsRequest = service.fetchListings()
            async let categoriesRequest = service.fetchCategories()
            let (listings, fetchedCategories) = try await (listingsRequest, categoriesRequest)

            let names = Dictionary(
                fetchedCategories.map { ($0.id, $0.name) },
                uniquingKeysWith: { first, _ in first }
            )
            categories = fetchedCategories
            items = listings.map {
                ListingItem(listing: $0, categoryName: names[$0.categoryId], baseURL: baseURL)
            }
            state = .loaded
        } catch {
            // A cancelled task (view gone, refresh interrupted) is not a user-facing error.
            state = Task.isCancelled ? previousState : .failed(error.localizedDescription)
        }
    }
}
