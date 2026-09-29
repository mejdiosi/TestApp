//
//  UrgentLabel.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 29/9/2026.
//


import SwiftUI

/// "Urgent" indicator (icon + text, so it doesn't rely on colour alone).
/// The caller sets the font.
struct UrgentLabel: View {
    var body: some View {
        Label("Urgent", systemImage: "exclamationmark.circle.fill")
            .foregroundColor(.orange)
    }
}