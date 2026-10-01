//
//  ListingListView.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import SwiftUI
import Combine

struct ListingListView: View {
    @StateObject private var viewModel: ListingListViewModel

    init(viewModel: ListingListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

  var body: some View {
    content
      .navigationTitle("Listings")
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search listings"
      )
      .autocorrectionDisabled()
      .task(id: viewModel.searchText) { await viewModel.search() }   
  }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading listings…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            StatusMessageView(
                systemImage: "wifi.exclamationmark",
                title: "Couldn't load listings",
                message: message,
                actionTitle: "Try again"
            ) {
                Task { await viewModel.load() }
            }
        case .loaded:
            VStack(spacing: 0) {
                CategoryFilterView(
                    categories: viewModel.categories,
                    selectedCategoryId: $viewModel.selectedCategoryId
                )
                listings
            }
        }
    }

    @ViewBuilder
    private var listings: some View {
        if viewModel.filteredItems.isEmpty {
          StatusMessageView(
            systemImage: "tray",
            title: "No listings",
            message: emptyMessage
          )
         
        } else {
          List(viewModel.filteredItems) { item in
            NavigationLink {
              ListingDetailView(item: item)
            } label: {
              ListingRowView(item: item)
            }
          }
            .listStyle(.plain)
            .id(viewModel.selectedCategoryId)//reset view
            .refreshable { await viewModel.load() }
        }
    }
  private var emptyMessage: String {
    let isFilteredByCategory = viewModel.selectedCategoryId != nil
    
    if let query = viewModel.activeQuery {
      return isFilteredByCategory
      ? "No results for “\(query)” in this category."
      : "No results for “\(query)”."
    }
    return isFilteredByCategory
    ? "There are no listings in this category."
    : "There are no listings yet."
  }
  
}
