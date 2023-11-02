//
//  EventsView.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import SwiftUI

struct EventsView: View {
  let events: [Event]

  @State var selectedEvent: Event?

  var body: some View {
    ScrollView {
      VStack {
        ForEach(events, id: \.id) { event in
          VStack {
            EventView(event: event, expanded: event == selectedEvent) {
              withAnimation(.easeOut(duration: 0.1)) {
                if event == selectedEvent {
                  selectedEvent = nil
                } else {
                  selectedEvent = event
                }
              }
            }
            Divider()
          }
        }
      }.padding(.top, 8)
    }
  }
}

struct EventView: View {
  let event: Event
  let expanded: Bool
  let onSelect: () -> Void

  private var weekday: String {
    event.startTimestamp.day.dayOfWeek.weekdaySymbol()
  }

  private var whenString: String {
    let date = event.startTimestamp.day.string(withStyle: .medium)
    let time = event.startTimestamp.timeOfDay.string(style: .default)
    return "\(date) @ \(time)"
  }

  private var whoString: String {
    let leaders = event.leaders
    let leadersString = leaders.map(\.name).humanReadableList()
    return "\(leadersString)"
  }

  private var leaders: [EnumeratedSequence<[Attendee]>.Element] {
    Array(event.leaders.enumerated())
  }

  var body: some View {
    HStack(alignment: .top) {
      VStack {
        ZStack(alignment: .top) {
          ForEach(leaders.reversed(), id: \.element.id) { item in
            UserIcon(user: item.element)
              .padding(.top, 20 * CGFloat(leaders.count - item.offset - 1))
          }
        }
        if event.enrolled {
          BookedBadge()
        }
        Spacer(minLength: 0)
      }.onTapGesture { onSelect() }
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "calendar.circle")
              Text(weekday).font(.headline)
            }
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "mappin.circle")
              Text(event.venue.name)
            }
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "person.circle")
              Text(whoString)
            }
            HStack(alignment: .firstTextBaseline) {
              Image(systemName: "clock")
              Text(whenString)
            }
          }
          Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
        if expanded {
          EventActionsView(event: event)
            .padding([.top, .leading], 4)
        }
      }
    }
    .grayscale(event.isInPast ? 1 : 0)
    .opacity(event.isInPast ? 0.6 : 1)
    .padding(.horizontal, 16)
  }
}

struct EventActionsView: View {

  @EnvironmentObject private var repository: Repository

  let event: Event

  var body: some View {
    HStack(spacing: 16) {
      BookButton(event: event)
      NavigationLink(
        destination: EventDetails(event: event).environmentObject(repository)
      ) {
        HStack(spacing: 2) {
          Text("View Details")
          Image(systemName: "chevron.right")
        }
      }
      .buttonStyle(.roundedButtonStyle)
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  EventsView(events: Event.examples,
             selectedEvent: Event.examples[1])
    .environmentObject(Repository(events: Event.examples))
}
