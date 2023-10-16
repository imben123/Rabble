//
//  RefreshEventsButton.swift
//  Rabble
//
//  Created by Ben Davis on 16/10/2023.
//

import SwiftUI

struct RefreshEventsButton: View {

  @Binding var event: Event

  @EnvironmentObject private var repository: Repository
  @State private var loading = false

  var body: some View {
    Button(action: refreshEvents) {
      Image(systemName: "arrow.triangle.2.circlepath")
    }
    .disabled(loading)
  }

  private func refreshEvents() {
    loading = true
    Task { @MainActor in
      guard let result = try? await repository.reloadEvent(event: event) else {
        loading = false
        return
      }
      event = result
      loading = false
    }
  }
}
