//
//  TestAppApp.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//

import SwiftUI


@main
struct TestAppApp: App {
  
  private var listingView: some View {
    ListingListView(
      viewModel: ListingListViewModel(
        service: APIService(baseURL: AppConfig.baseURL),
        baseURL: AppConfig.baseURL
      )
    )
  }
  
  var body: some Scene {
    WindowGroup {
      if #available(iOS 16.0, *) {
        NavigationSplitView {
          listingView
        } detail: {
          if #available(iOS 17.0, *) {
            ContentUnavailableView(
              "Sélectionnez une annonce",
              systemImage: "rectangle.and.text.magnifyingglass",
              description: Text(
                "Choisissez une annonce pour voir ses détails."
              )
            )
          } else {
            Text("Sélectionnez une annonce")
              .foregroundStyle(.secondary)
          }
        }
      } else {
        NavigationView {
          listingView
        }
      }
    }
  }
}
