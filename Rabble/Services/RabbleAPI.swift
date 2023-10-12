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
  
  static let shared = RabbleAPI()

  var userToken = "8348cd741a06a04777db3ed205e092a72a5c36e451e32d01f1c4ad8406a6e8ce"

  private let urlSession: URLSession = {
    let session = URLSession(configuration: .default)
    return session
  }()

  func getEvents() async throws -> [Event] {
    let fromDate = (CalendarDate.today - 1).makeSweatStringURLEncoded
    let toDate = (CalendarDate.today + 365).makeSweatStringURLEncoded
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://makesweat.com/service/event_m.php?listevents=1&clubid=225&start=\(fromDate)&end=\(toDate)&makesweatuserident=\(userToken)")!)
    let rawEvents = try JSONDecoder().decode([EventRaw].self, from: data)
    let events = rawEvents.compactMap { try? Event(raw: $0) }
    return events
  }

  func getEventPasses(event: Event) async throws -> EventPasses {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://makesweat.com/service/event_m.php?listuserpasstypesbyevent=\(event.id)&makesweatuserident=\(userToken)")!)
    let raw = try JSONDecoder().decode(EventPassesRaw.self, from: data)
    let result = EventPasses(raw: raw)
    return result
  }

  func bookEvent(event: Event, pass: Passtype) async throws -> APIMessage {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://makesweat.com/service/event_m.php?makesweatuserident=\(userToken)&join=\(event.id)&passid=\(pass.passID)")!)
    return try JSONDecoder().decode(APIMessage.self, from: data)
  }

  func cancelEvent(event: Event) async throws -> APIMessage {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://makesweat.com/service/event_m.php?makesweatuserident=\(userToken)&attend=unattend&eventid=\(event.id)")!)
    return try JSONDecoder().decode(APIMessage.self, from: data)
  }
}

struct APIMessage: Model {
  let success: Bool
  let message: String
  let event: EventRaw?
}
