//
//  UrgentLabel.swift
//  TestApp
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
