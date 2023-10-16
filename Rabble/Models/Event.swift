//
//  Event.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import Foundation
import FoundationPlus
import Time
import CoreLocation

struct EventRaw: Model {
  let EventID: String
  var StartTime: String
  var EndTime: String
  let tz: String
  let Vnotes: String?
  let Places: String
  let numattendees: String
  let Attendees: String?
  let Venue: String
  let Address: String?
  let Postcode: String?
  let Lat: String?
  let Lon: String?
  let utoeID: String // "0" means not enrolled, anything else means enrolled
}

struct Event: Model {
  let id: String
  let startTimestamp: Timestamp
  let endTimestamp: Timestamp
  let notes: String?

  let numberOfPlaces: Int
  let numberOfAttendees: Int

  let attendees: [Attendee]

  let venue: Venue

  var enrolled: Bool

  let updatedAt: Timestamp

  var leaders: [Attendee] {
    attendees.filter(\.isLeader)
  }
}

extension Event {
  init(raw: EventRaw) throws {
    self.id = raw.EventID
    let timeZoneString = raw.tz.replacingOccurrences(of: "\\/", with: "/")
    let timeZone = TimeZone(identifier: timeZoneString) ?? .europeLondon
    self.startTimestamp = try Timestamp(makeSweatString: raw.StartTime, timeZone: timeZone)
    self.endTimestamp = try Timestamp(makeSweatString: raw.EndTime, timeZone: timeZone)
    self.notes = raw.Vnotes

    self.numberOfPlaces = Int(raw.Places) ?? 100
    self.numberOfAttendees = Int(raw.numattendees) ?? 0

    self.attendees = .init(attendeesString: raw.Attendees)

    self.venue = Venue(
      name: raw.Venue,
      address: raw.Address,
      postcode: raw.Postcode,
      coords: CLLocationCoordinate2D(latitude: raw.Lat, longitude: raw.Lon)
    )

    self.enrolled = (Int(raw.utoeID) ?? 0) > 0

    self.updatedAt = Timestamp.now
  }
}

extension Event {
  var isInPast: Bool {
    endTimestamp.isInPast
  }
}

extension Event {
  func eventByUpdating(withRaw raw: EventRaw) -> Event {
    return Event(
      id: id,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      notes: notes,
      numberOfPlaces: Int(raw.Places) ?? 100,
      numberOfAttendees: Int(raw.numattendees) ?? 0,
      attendees: .init(attendeesString: raw.Attendees),
      venue: venue,
      enrolled: (Int(raw.utoeID) ?? 0) > 0, 
      updatedAt: updatedAt
    )
  }
}
