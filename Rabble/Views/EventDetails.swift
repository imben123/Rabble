//
//  EventDetails.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI
import MapKit

struct EventDetails: View {
  
  let event: Event
  let region: MKCoordinateRegion?

  init(event: Event) {
    self.event = event
    if let coords = event.venue.coords {
      self.region = MKCoordinateRegion(
        center: coords,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    } else {
      self.region = nil
    }
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

  private var hasTooManyMapsApps: Bool {
    MapLauncher.isMapAppInstalled(.appleMaps) &&
    MapLauncher.isMapAppInstalled(.googleMaps) &&
    MapLauncher.isMapAppInstalled(.citymapper) &&
    MapLauncher.isMapAppInstalled(.waze)
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 20) {
        ZStack {
          ForEach(leaders, id: \.element.id) { item in
            UserIcon(user: item.element, size: 100)
              .offset(x: 20 * CGFloat(item.offset))
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
            Text("Booked")
              .font(.caption)
              .padding(.horizontal, 4)
              .padding(.vertical, 2)
              .background(Color.rabbleOrange)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .foregroundColor(.white)
              .padding(.top, 2)
          }
        }
        Spacer(minLength: 0)
      }
      
      Divider()

      HStack(alignment: .firstTextBaseline) {
        Image(systemName: "mappin.circle")
        VStack(alignment: .leading) {
          Text(event.venue.name).font(.headline)
          if let address = event.venue.fullAddressString {
            Text(address)
          }
        }
      }
      VStack {
        if let region, let coords = event.venue.coords {
          Map(initialPosition: .region(region), interactionModes: []) {
            Marker("Rabble", coordinate: coords)
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .frame(height: 200)
        }
        if event.venue.placemark != nil {
          HStack {
            RoundedButton(action: { launchMap(.appleMaps) }) {
              HStack(alignment: .center, spacing: 4) {
                Text("").offset(y: -1)
                Text("Maps").font(.caption)
              }
            }
            if MapLauncher.isMapAppInstalled(.googleMaps) {
              RoundedButton(action: { launchMap(.googleMaps) }) {
                HStack(spacing: 4) {
                  Image("GoogleMaps")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 20)
                  Text("Google").font(.caption)
                }
              }
            }
            if MapLauncher.isMapAppInstalled(.citymapper) {
              RoundedButton(action: { launchMap(.citymapper) }) {
                HStack {
                  Image("Citymapper")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                  Text("Citymapper").font(.caption).hidden(hasTooManyMapsApps)
                }
              }
            }
            if MapLauncher.isMapAppInstalled(.waze) {
              RoundedButton(action: { launchMap(.waze) }) {
                HStack {
                  Image("Waze")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                  Text("Waze").font(.caption).hidden(hasTooManyMapsApps)
                }
              }
            }
          }
        }
      }.padding(.leading, 28)

      Divider()

      HStack {
        Image(systemName: "person.2.circle")
        Text("Attendees").font(.headline)
      }
      Grid(alignment: .leading) {
        ForEach(event.attendees.chunked(into: 2), id: \.self) { attendeeRow in
          GridRow {
            ForEach(attendeeRow, id: \.self) { attendee in
              HStack {
                UserIcon(user: attendee, size: 25)
                Text(attendee.name)
                Spacer()
              }
            }
          }
        }
      }.padding(.leading, 28)

      Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .navigationTitle(title)
  }

  private func launchMap(_ app: MapApp) {
    MapLauncher.launch(mapApp: app, withVenue: event.venue)
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
  }
}
