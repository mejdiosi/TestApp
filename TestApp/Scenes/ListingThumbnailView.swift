//
//  ListingThumbnailView.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import SwiftUI

/// Remote image with a placeholder for missing URLs, loading and failures.
struct ListingThumbnailView: View {
    let url: URL?
    let size: CGFloat

    var body: some View {
        Group {
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
        .frame(width: size, height: size)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .foregroundColor(.secondary)
    }
}