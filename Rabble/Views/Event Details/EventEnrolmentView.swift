//
//  EventEnrolmentView.swift
//  Rabble
//
//  Created by Ben Davis on 17/10/2023.
//

import SwiftUI

struct EventEnrolmentView: View {

  let event: Event

  private var spacesString: String {
    if event.numberOfPlaces > event.numberOfAttendees {
      let remainingSpaces = event.numberOfPlaces - event.numberOfAttendees
      if remainingSpaces > 1 {
        return "There are \(remainingSpaces) spaces remaining out of \(event.numberOfPlaces)."
      } else {
        return "There is 1 space remaining out of \(event.numberOfPlaces)."
      }
    } else {
      return "This event is fully booked. There were \(event.numberOfPlaces) spaces."
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "ticket")
        Text("Booking").font(.headline)
      }
      VStack(alignment: .leading) {
        if event.enrolled {
          Text("You are booked on this event ✅")
        }
        Text(spacesString)
        BookButton(event: event)
      }.padding(.leading, 33)
    }
  }
}

#Preview {
  EventEnrolmentView(event: Event.examples[1])
    .environmentObject(Repository(events: Event.examples))
}
