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
