//
//  ListingRowView.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import SwiftUI

struct ListingRowView: View {
  let item: ListingItem
  
  @ScaledMetric private var thumbnailSize: CGFloat = 88
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      RemoteImageView(url: item.thumbnailURL)
        .frame(width: thumbnailSize, height: thumbnailSize)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(item.categoryName)
          .font(.caption)
          .foregroundColor(.secondary)
        Text(item.title)
          .font(.headline)
          .lineLimit(2)
        Text(item.formattedPrice)
          .font(.subheadline.bold())
        if item.isUrgent {
          UrgentLabel()
            .font(.caption.bold())
        }
      }
    }
    .padding(.vertical, 4)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(accessibilityDescription)
  }
  
  private var accessibilityDescription: String {
    [item.title, item.formattedPrice, item.categoryName, item.isUrgent ? "Urgent" : nil]
      .compactMap { $0 }
      .joined(separator: ", ")
  }
}
