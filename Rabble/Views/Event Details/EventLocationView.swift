//
//  EventLocationView.swift
//  Rabble
//
//  Created by Ben Davis on 16/10/2023.
//

import SwiftUI
import MapKit

struct EventLocationView: View {
  let venue: Venue
  let notes: String?

  private var region: MKCoordinateRegion? {
    venue.coords?.region
  }

  private var hasTooManyMapsApps: Bool {
    MapLauncher.isMapAppInstalled(.appleMaps) &&
    MapLauncher.isMapAppInstalled(.googleMaps) &&
    MapLauncher.isMapAppInstalled(.citymapper) &&
    MapLauncher.isMapAppInstalled(.waze)
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: "mappin.circle")
        VStack(alignment: .leading) {
          Text(venue.name).font(.headline)
          if let address = venue.fullAddressString {
            Text(address)
          }
        }
      }
      VStack(alignment: .leading) {
        if let region, let coords = venue.coords {
          Map(initialPosition: .region(region), interactionModes: []) {
            Marker("Rabble", coordinate: coords)
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .frame(height: 200)
        }
        if venue.placemark != nil {
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
        if let notes {
          Text("Details").bold()
          Text(notes)
        }
      }.padding(.leading, 28)
    }
  }

  private func launchMap(_ app: MapApp) {
    MapLauncher.launch(mapApp: app, withVenue: venue)
  }
}

private extension CLLocationCoordinate2D {
  var region: MKCoordinateRegion {
    MKCoordinateRegion(
      center: self,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
  }
}

#Preview {
  EventLocationView(venue: Event.examples[1].venue,
                    notes: Event.examples[1].notes)
    .padding()
}
