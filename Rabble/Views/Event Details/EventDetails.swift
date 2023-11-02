//
//  EventDetails.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

struct EventDetails: View {
  
  @State private var event: Event

  init(event: Event) {
    self._event = State(initialValue: event)
  }

  private var title: String {
    let leaders = event.leaders
    let leadersString = leaders.map(\.name).humanReadableList()
    return "Rabble with \(leadersString)"
  }

  private var weekday: String {
    event.startTimestamp.day.dayOfWeek.weekdaySymbol()
  }

  private var dateString: String {
    return event.startTimestamp.day.string(withStyle: .long)
  }

  private var timeString: String {
    return event.startTimestamp.timeOfDay.string(style: .default)
  }

  private var leaders: [EnumeratedSequence<[Attendee]>.Element] {
    Array(event.leaders.enumerated())
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack(spacing: 20) {
          ZStack(alignment: .top) {
            ForEach(leaders.reversed(), id: \.element.id) { item in
              UserIcon(user: item.element, size: leaders.count == 1 ? 100 : 65)
                .padding(.top, 20 * CGFloat(leaders.count - item.offset - 1))
            }
          }
          VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "newspaper.circle")
              Text(weekday).font(.headline)
            }
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "calendar.circle")
              Text(dateString)
            }
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "clock")
              Text(timeString)
            }
            if event.enrolled {
              BookedBadge()
            }
          }
          Spacer(minLength: 0)
        }

        Divider().padding(.vertical, 4)

        EventLocationView(venue: event.venue, notes: event.notes)

        Divider().padding(.vertical, 4)

        EventAttendeesView(attendees: event.attendees, totalAttendees: event.numberOfAttendees)

        Divider().padding(.vertical, 4)

        EventEnrolmentView(event: event)

        HStack {
          Spacer()
          Text("Last updated: \(event.updatedAt.updatedAtString)")
            .font(.footnote)
            .foregroundColor(Color(.lightGray))
          Spacer()
        }.padding(.top, 26)

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
    }
    .navigationTitle(title)
    .toolbar {
      RefreshEventsButton(event: $event)
    }
  }
}

extension View {
  @ViewBuilder
  func hidden(_ hide: Bool) -> some View {
    if !hide {
      self
    } else {
      EmptyView()
    }
  }
}

#Preview {
  NavigationView {
    EventDetails(event: Event.examples[1])
      .environmentObject(Repository(events: Event.examples))
  }
}
