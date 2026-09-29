//
//  RemoteImageView.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 29/9/2026.
//


import SwiftUI


struct RemoteImageView: View {
  let url: URL?
  
  var body: some View {
    Color(.secondarySystemBackground)
      .overlay { content }
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
  
  @ViewBuilder
  private var content: some View {
    if let url {
      AsyncImage(url: url) { phase in
        switch phase {
          case .success(let image):
            image.resizable().scaledToFill()
          case .empty:
            ProgressView()
          case .failure:
            placeholder
          @unknown default:
            placeholder
        }
      }
    } else {
      placeholder
    }
  }
  
  private var placeholder: some View {
    Image(systemName: "photo")
      .foregroundColor(.secondary)
  }
}
