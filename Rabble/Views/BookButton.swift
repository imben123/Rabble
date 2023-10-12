//
//  BookButton.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

struct BookButton: View {

  let event: Event

  @EnvironmentObject private var repository: Repository
  @State private var processing = false
  @State private var bookingError: String?

  private var loading: Bool {
    repository.isLoadingPasses(for: event)
  }

  private var title: String {
    event.enrolled ? "Cancel" : "Book"
  }

  private var errorTitle: String {
    if event.enrolled {
      return "Error cancelling event"
    } else {
      return "Error booking event"
    }
  }

  private var enabled: Bool {
    guard !processing else {
      return false
    }
    if event.enrolled {
      return repository.canCancelEvent(event: event)
    } else {
      return repository.canBookEvent(event: event)
    }
  }

  private var showingBookingErrorAlert: Binding<Bool> {
    Binding(get: { bookingError != nil }, set: { newValue in
      if newValue && bookingError == nil {
        bookingError = ""
      } else if !newValue && bookingError != nil {
        bookingError = nil
      }
    })
  }

  var body: some View {
    RoundedButton(action: event.enrolled ? cancelEvent : bookEvent) {
      ZStack {
        Text(title).opacity(processing || loading ? 0 : 1)
        if processing || loading {
          ProgressView()
        }
      }
    }
    .disabled(!enabled)
    .alert(isPresented: showingBookingErrorAlert) {
        Alert(title: Text(errorTitle),
              message: Text(bookingError ?? "Unknown error"),
              dismissButton: .default(Text("OK")))
    }
  }

  private func bookEvent() {
    processing = true
    Task {
      do {
        try await repository.bookEvent(event: event)
      } catch let error {
        bookingError = error.localizedDescription
      }
      processing = false
    }
  }

  private func cancelEvent() {
    processing = true
    Task {
      do {
        try await repository.cancelEvent(event: event)
      } catch let error {
        bookingError = error.localizedDescription
      }
      processing = false
    }
  }
}
