//
//  Repository.swift
//  Rabble
//
//  Created by Ben Davis on 11/10/2023.
//

import Foundation
import FoundationPlus
import Time

final class Repository: ObservableObject {
  static let shared = Repository()

  private let api = RabbleAPI.shared

  @UserDefaultsStored(key: "events")
  var events: [Event]? = nil {
    willSet {
      if newValue != events {
        self.objectWillChange.send()
      }
    }
  }

  @Published var eventPasses: [String: EventPasses] = [:]
  @Published var loadingEventPasses = false
  @Published var loadingEventPassesProgress = 0

  private init() {}

  convenience init(events: [Event], loadingEventPasses: Bool = false) {
    self.init()
    self.events = events
    self.loadingEventPasses = loadingEventPasses
    self.loadingEventPassesProgress = 10
  }
}

// MARK: -
extension Repository {
  func isLoadingPasses(for event: Event) -> Bool {
    return eventPasses[event.id] == nil && loadingEventPasses
  }

  @MainActor func fetchEvents() async throws {
    events = try await api.getEvents()
    loadingEventPasses = true
    Task {
      try await withThrowingTaskGroup(of: (String, EventPasses?).self) { group in
        for event in events ?? [] {
          group.addTask {
            let result = try? await self.api.getEventPasses(event: event)
            return (event.id, result)
          }
        }
        
        for try await (id, passes) in group where passes != nil {
          loadingEventPassesProgress += 1
          eventPasses[id] = passes
        }
      }
      loadingEventPasses = false
    }
  }

  func canBookEvent(event: Event) -> Bool {
    guard let passes = eventPasses[event.id] else {
      return false
    }
    return !event.enrolled && !passes.availablePasses.isEmpty && event.startTimestamp.isInFuture
  }

  @MainActor func bookEvent(event: Event) async throws {
    guard canBookEvent(event: event),
          let passes = eventPasses[event.id],
          let pass = passes.availablePasses.first else {
      return
    }
    let result = try await api.bookEvent(event: event, pass: pass)
    if !result.success {
      throw RabbleBookingError.gotNonSuccessResponse(message: result.message)
    }
    guard let updatedEventDetails = result.event,
          let index = events?.firstIndex(of: event) else {
      return
    }
    events?[index] = event.eventByUpdating(withRaw: updatedEventDetails)
  }

  func canCancelEvent(event: Event) -> Bool {
    return event.enrolled && event.startTimestamp.isInFuture
  }

  @MainActor func cancelEvent(event: Event) async throws {
    guard canCancelEvent(event: event) else {
      return
    }
    let result = try await api.cancelEvent(event: event)
    if !result.success {
      throw RabbleBookingError.gotNonSuccessResponse(message: result.message)
    }
    guard let index = events?.firstIndex(of: event) else {
      return
    }
    events?[index].enrolled = false
  }
}

enum RabbleBookingError: Error, LocalizedError {
  case gotNonSuccessResponse(message: String)

  var errorDescription: String? {
    switch self {
    case .gotNonSuccessResponse(let message):
      return message
    }
  }
}
