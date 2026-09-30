//
//  ListingDetailView.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 29/9/2026.
//


import SwiftUI

struct ListingDetailView: View {
    let item: ListingItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ListingImageView(url: item.imageURL)
                    .aspectRatio(4 / 3, contentMode: .fit)
                    .accessibilityHidden(true)

                header

                if !item.description.isEmpty {
                    Divider()
                    description
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            if item.isUrgent {
                UrgentLabel()
                    .font(.subheadline.bold())
            }
            Text(item.title)
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
            Text(item.formattedPrice)
                .font(.title3.bold())
                .foregroundColor(.accentColor)
            Text(item.categoryName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Posted on \(item.formattedDate)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(item.description)
                .font(.body)
        }
    }
}
