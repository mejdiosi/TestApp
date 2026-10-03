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
    case loading
    case loaded
    case failed(String)
  }
  @Published var searchText = ""
  
  @Published private(set) var state: State = .loading
  @Published private(set) var categories: [Category] = []
  @Published var selectedCategoryId: Int? //all
  @Published private var items: [ListingItem] = []
  
  private let service: APIServiceProtocol
  private let baseURL: URL
  private let searchDebounce: Duration
  
  
  init(service: APIServiceProtocol, baseURL: URL, searchDebounce: Duration = .milliseconds(300)) {
    self.service = service
    self.baseURL = baseURL
    self.searchDebounce = searchDebounce
  }
  
  
  var activeQuery: String? {
    let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    return query.isEmpty ? nil : query
  }
  
  func search() async {
    if activeQuery != nil {
      try? await Task.sleep(for: searchDebounce)
      guard !Task.isCancelled else { return }
    }
    await load()
  }
  
    /// Items for the selected category. The API order is preserved.
  var filteredItems: [ListingItem] {
    guard let selectedCategoryId else { return items }
    return items.filter { $0.categoryId == selectedCategoryId }
  }
  
  func load() async {
      // Keep the current list visible while refreshing.
    if state != .loaded { state = .loading }
    
    do {
      async let listingsRequest = service.fetchListings(query: activeQuery)
      async let categoriesRequest = categoriesForLoad()
      let (loadedListings, loadedCategories) = try await (listingsRequest, categoriesRequest)
      
      categories = loadedCategories
      items = loadedListings.map { listing in
        let categoryName = loadedCategories.first { $0.id == listing.categoryId }?.name
        return ListingItem(listing: listing, categoryName: categoryName, baseURL: baseURL)
      }
      state = .loaded
    } catch {
        // A cancelled load (leaving the screen, interrupted refresh) isn't an error to show.
      guard !Task.isCancelled else { return }
      state = .failed(error.localizedDescription)
    }
  }
  
    /// Categories rarely change: fetch them once, then reuse them (e.g. on every search).
  private func categoriesForLoad() async throws -> [Category] {
    if !categories.isEmpty { return categories }
    return try await service.fetchCategories()
  }
}
