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
      .navigationTitle("Annonces")
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Rechercher une annonce"
      )
      .autocorrectionDisabled()
      .task(id: viewModel.searchText) { await viewModel.search() }   
  }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Chargement des annonces…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            StatusMessageView(
                systemImage: "wifi.exclamationmark",
                title: "Impossible de charger les annonces",
                message: message,
                actionTitle: "Réessayer"
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
            .frame(maxWidth: 700)
          .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var listings: some View {
        if viewModel.filteredItems.isEmpty {
          StatusMessageView(
            systemImage: "tray",
            title: "Aucune annonce",
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
            .scrollContentBackground(.hidden)
            .id(viewModel.selectedCategoryId)//reset view
            .refreshable { await viewModel.load() }
        }
    }
  private var emptyMessage: String {
    let isFilteredByCategory = viewModel.selectedCategoryId != nil
    
    if let query = viewModel.activeQuery {
      return isFilteredByCategory
      ? "Aucun résultat pour “\(query)” in this category."
      : "Aucun résultat pour « \(query) » dans cette catégorie."
    }
    return isFilteredByCategory
    ? "There are no listings in this category."
    : "Il n'y a pas encore d'annonces."
  }
  
}
