//
//  EventAttendeesView.swift
//  Rabble
//
//  Created by Ben Davis on 16/10/2023.
//

import SwiftUI

struct EventAttendeesView: View {
  let attendees: [Attendee]
  let totalAttendees: Int

  private var attendeesAndPlaceholder: [AttendeeOrPlaceholder] {
    var result: [AttendeeOrPlaceholder] = attendees.map { .attendee($0) }
    if attendees.count < totalAttendees {
      result.append(.placeholder)
    }
    return result
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "person.2.circle")
        Text("Attendees (\(totalAttendees))").font(.headline)
      }
      Grid(alignment: .leading) {
        ForEach(attendeesAndPlaceholder.chunked(into: 2), id: \.self) { attendeeRow in
          GridRow {
            ForEach(attendeeRow, id: \.self) { attendee in
              HStack {
                UserIcon(user: attendee.userType, size: 25)
                switch attendee {
                case .attendee(let attendee):
                  Text(attendee.name)
                case .placeholder:
                  if totalAttendees - attendees.count == 1 {
                    Text("(1 other)")
                  } else {
                    Text("(\(totalAttendees - attendees.count) others)")
                  }
                }
                Spacer()
              }
            }
          }
        }
      }.padding(.leading, 28)
    }
  }
}

private enum AttendeeOrPlaceholder: Identifiable, Hashable {
  case attendee(Attendee)
  case placeholder

  var id: String {
    switch self {
    case .attendee(let attendee):
      return attendee.id
    case .placeholder:
      return "placeholder"
    }
  }

  var userType: UserType {
    switch self {
    case .attendee(let attendee):
      return attendee
    case .placeholder:
      return PlaceholderUserType()
    }
  }
}

private struct PlaceholderUserType: UserType {
  var initials: String { "..." }
  var imageURL: URL? { nil }
}

#Preview {
  EventAttendeesView(attendees: Event.examples[1].attendees, 
                     totalAttendees: 10).padding()
}
