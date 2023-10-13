//
//  LoadEventsView.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

struct LoadEventsView: View {

  @EnvironmentObject private var repository: Repository
  @State private var errorMessage: String?

  var statusText: String? {
    if let errorMessage {
      return errorMessage
    } else if repository.events == nil {
      return "Updating events..."
    }
    return nil
  }

  var body: some View {
    VStack(spacing: 0) {
      StatusView(text: statusText, error: errorMessage != nil)
        .animation(.easeOut, value: statusText == nil)
      EventsView(events: repository.events ?? [])
    }
    .task {
      do {
        errorMessage = nil
        try await repository.updateEvents()
      } catch let error {
        errorMessage = error.localizedDescription
      }
    }
  }
}

struct StatusView: View {
  let text: String?
  var error = false
  var body: some View {
    VStack {
      Spacer(minLength: 1).frame(height: 1)
      HStack {
        Spacer()
        Text(text ?? "")
          .foregroundColor(.white)
          .padding(.vertical, 4)
        Spacer()
      }
    }
    .background(text == nil ? nil : (error ? Color.error : Color.rabbleOrange))
    .frame(maxHeight: text == nil ? 0 : nil)
  }
}

#Preview {
  LoadEventsView()
    .environmentObject(
      Repository(events: Event.examples, loadingEventPasses: true)
    )
}
