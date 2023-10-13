//
//  Timestamp+MakeSweat.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import Time

extension Timestamp {
  private static let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.timeZone = .utc
    result.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return result
  }()

  init(makeSweatString: String, timeZone: TimeZone) throws {
    guard let date = Self.dateFormatter.date(from: makeSweatString) else {
      throw Timestamp.Error.invalidISO8601String
    }
    self.init(date: date, timeZone: timeZone)
  }

  var makeSweatString: String {
    Self.dateFormatter.string(from: date)
  }

  var makeSweatStringURLEncoded: String {
    makeSweatString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  }

  var isInFuture: Bool {
    date > .now
  }

  var isInPast: Bool {
    date < .now
  }

  static var now: Timestamp {
    Timestamp(date: .now, timeZone: .autoupdatingCurrent)
  }
}

extension CalendarDate {
  var makeSweatString: String {
    iso8601StringRepresentation + " 00:00:00"
  }

  var makeSweatStringURLEncoded: String {
    makeSweatString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  }

  static var today: CalendarDate {
    CalendarDate(date: Date(), timeZone: .autoupdatingCurrent)
  }
}
