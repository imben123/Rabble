//
//  RabbleAPI.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import Foundation
import FoundationPlus
import Time

final class RabbleAPI {

  private let baseURL = URL(string: "https://makesweat.com")!
  var userToken: String?

  init(userToken: String? = nil) {
    self.userToken = userToken
  }

  private let urlSession: URLSession = {
    let session = URLSession(configuration: .default)
    return session
  }()

  func login(email: String, password: String) async throws -> UserRaw {
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
    urlComponents.path = "/service/user_m.php"
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "POST"
    request.httpBody = "emaillogin=\(email)&passwordlogin=\(password)".data(using: .utf8)!
    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(UserRaw.self, from: data)
  }

  func getEvents() async throws -> [Event] {
    let fromDate = (CalendarDate.today - 1).makeSweatString
    let toDate = (CalendarDate.today + 365).makeSweatString
    let rawEvents: [EventRaw] = try await makeEventRequest(queryItems: [
      "listevents": "1",
      "clubid": "225",
      "start": fromDate,
      "end": toDate
    ])
    let events = rawEvents.compactMap { try? Event(raw: $0) }
    return events.sortedInAscendingOrder(by: \.startTimestamp.date)
  }

  func getEventPasses(event: Event) async throws -> EventPasses {
    let raw: EventPassesRaw = try await makeEventRequest(queryItems: [
      "listuserpasstypesbyevent": event.id
    ])
    let result = EventPasses(raw: raw)
    return result
  }

  func bookEvent(event: Event, pass: Passtype) async throws -> APIMessage {
    return try await makeEventRequest(queryItems: [
      "passid": "\(pass.passID)",
      "join": event.id
    ])
  }

  func cancelEvent(event: Event) async throws -> APIMessage {
    return try await makeEventRequest(queryItems: [
      "attend": "unattend",
      "eventid": event.id
    ])
  }

  private func makeEventRequest<T: Codable>(queryItems: [String: String]) async throws -> T {
    var queryItemsWithUserToken = queryItems
    if let userToken {
      queryItemsWithUserToken["makesweatuserident"] = userToken
    }
    return try await makeRequest(path: "/service/event_m.php", queryItems: queryItemsWithUserToken)
  }

  private func makeRequest<T: Codable>(path: String, queryItems: [String: String]) async throws -> T {
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
    urlComponents.path = path
    urlComponents.queryItems = queryItems.map { (key, value) in
      URLQueryItem(name: key, value: value)
    }
    let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
    return try JSONDecoder().decode(T.self, from: data)
  }
}

struct APIMessage: Model {
  let success: Bool
  let message: String
  let event: EventRaw?
}
