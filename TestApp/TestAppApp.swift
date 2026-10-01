//
//  TestAppApp.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//

import SwiftUI


@main
struct TestAppApp: App {
  
  var body: some Scene {
    WindowGroup {
      ListingListView(
        viewModel: ListingListViewModel(
          service: APIService(baseURL: AppConfig.baseURL),
          baseURL: AppConfig.baseURL
        )
      )
    }
  }
}
