//
//  ExampleData.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import Foundation
import Time

extension Event {
  static let examples: [Event] = {
    let data = try! Data(contentsOf: Bundle.main.url(forResource: "example-events", withExtension: "json")!)
    let rawEvents = try! JSONDecoder().decode([EventRaw].self, from: data)
    return rawEvents
      .map { $0.shiftDates() }
      .map { try! Event(raw: $0) }
  }()
}

extension EventRaw {
  func shiftDates() -> EventRaw {
    var result = self
    result.StartTime = shift(string: StartTime)
    result.EndTime = shift(string: EndTime)
    return result
  }

  private static var shiftDays: Int = {
    CalendarDate.today - (try! CalendarDate(day: 10, month: 10, year: 2023))
  }()

  private func shift(string: String) -> String {
    let timestamp = try! Timestamp(makeSweatString: string, timeZone: .current)
    let updatedTimestamp = shift(timestamp: timestamp)
    return updatedTimestamp.makeSweatString
  }

  private func shift(timestamp: Timestamp) -> Timestamp {
    let dateTime = timestamp.dateTime
    let shiftedDateTime = DateTime(calendarDate: dateTime.calendarDate + Self.shiftDays,
                                   timeOfDay: dateTime.timeOfDay)
    return shiftedDateTime.timestamp(in: .current)
  }
}

extension EventPasses {
  static let example: EventPasses = {
    let data = try! Data(contentsOf: Bundle.main.url(forResource: "example-passtypes", withExtension: "json")!)
    let raw = try! JSONDecoder().decode(EventPassesRaw.self, from: data)
    return EventPasses(raw: raw)
  }()
}

extension User {
  static let examples: [User] = {
    let json = [
      "{\"UserID\":\"29669\",\"Firstname\":\"Ben\",\"Lastname\":\"Davis\",\"Username\":\"Ben Davis\",\"Image\":\"\",\"StripeCustomer\":\"cus_KVBSrEoX1jdQL6\",\"current\":0,\"ms_live\":1,\"kiosk\":0,\"numbasketitems\":0,\"success\":true,\"message\":\"Welcome Ben Davis\",\"UserIdent\":\"99a5006f4d8dac36af85adea5583ded2a39769467a4a9cd71261ec1700af50ee\"}",
      "{\"UserID\":\"13750\",\"Firstname\":\"Sara\",\"Lastname\":\"Santos\",\"Username\":\"Sara Santos\",\"Image\":\"8a69e9169a10d053230fa95396c427d5\",\"StripeCustomer\":\"cus_GuLG8O3RccTtCL\",\"current\":0,\"ms_live\":1,\"kiosk\":0,\"numbasketitems\":0,\"success\":true,\"message\":\"Welcome Sara Santos\",\"UserIdent\":\"56827e553a20878c79bc0efdc112942f065a656190d4beeb58876bf387bcc8a6\"}"
    ]
    return json
      .map { $0.data(using: .utf8)! }
      .map { try! JSONDecoder().decode(UserRaw.self, from: $0) }
      .map { User(raw: $0) }
//      .reversed()
  }()
}
