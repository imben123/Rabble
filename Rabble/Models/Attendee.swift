//
//  Attendee.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus

struct Attendee: Model {
  let id: String
  let name: String
  let type: AttendeeType

  var isLeader: Bool {
    return type == .leader
  }

  var imageURL: URL? {
    guard id != "" else {
      return nil
    }
    return URL(string: "https://makesweat.com/userfiles/filethumbs/\(id)_64.jpg")
  }
}

enum AttendeeType: Model {
  case regular
  case leader

  init(typeString: String) {
    guard let intVal = Int(typeString) else {
      self = .regular
      return
    }
    self = intVal > 0 ? .leader : .regular
  }
}

extension Array where Element == Attendee {
  init(attendeesString: String?) {
    self = attendeesString?.split(separator: ",").map { attendeeString in
      let attendeeComponents = attendeeString.split(separator: ":")
      let attendeeComponentStrings = attendeeComponents.map { sub in String(sub) }
      let id = attendeeComponentStrings[safe: 1] ?? ""
      let name = attendeeComponentStrings[safe: 0] ?? "Unknown"
      let typeString = attendeeComponentStrings[safe: 2] ?? "1"
      return Attendee(id: id, name: name, type: AttendeeType(typeString: typeString))
    } ?? []
  }
}
