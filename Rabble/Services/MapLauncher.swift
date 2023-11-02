//
//  MapLauncher.swift
//  Rabble
//
//  Created by Ben Davis on 13/10/2023.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import FoundationPlus
import MapKit
import Contacts

enum MapApp: Equatable {
  case appleMaps, citymapper, googleMaps, waze

  var urlPrefix: String? {
    switch self {
    case .appleMaps: return nil
    case .citymapper: return "citymapper://"
    case .googleMaps: return "comgooglemaps://"
    case .waze: return "waze://"
    }
  }
}

struct MapLauncher {
  static func isMapAppInstalled(_ mapApp: MapApp) -> Bool {
    if TestHelper.isRunningSwifTUIPreviews() {
      return true
    }

    if mapApp == .appleMaps {
      return true
    }

    guard let urlPrefix = mapApp.urlPrefix else {
      return false
    }

#if canImport(UIKit)
    return UIApplication.shared.canOpenURL(URL(string: urlPrefix)!)
#else
    return false
#endif
  }

  static func launch(mapApp: MapApp, withVenue venue: Venue) {
    if !MapLauncher.isMapAppInstalled(mapApp) {
      return
    }

    switch mapApp {
    case .appleMaps:
      guard let placemark = venue.placemark else {
        return
      }

      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = venue.name
      mapItem.openInMaps()

    case .googleMaps:
      guard let coords = venue.coords else {
        return
      }
      let url = "https://www.google.com/maps/search/?api=1&query=\(coords.latitude)%2C\(coords.longitude)"
      open(URL(string: url)!)

    case .citymapper:
      var urlComponents = URLComponents(string: "citymapper://directions")!
      urlComponents.queryItems = []
      if let coords = venue.coords {
        urlComponents.queryItems?.append(URLQueryItem(name: "endcoord", value: "\(coords.latitude),\(coords.longitude)"))
      }
      urlComponents.queryItems?.append(URLQueryItem(name: "endname", value: venue.name))
      if let fullAddressString = venue.fullAddressString {
        urlComponents.queryItems?.append(URLQueryItem(name: "endaddress", value: fullAddressString))
      }
      if let url = urlComponents.url {
        open(url)
      }
      
    case .waze:
      guard let coords = venue.coords else {
        return
      }
      var urlComponents = URLComponents(string: "waze://")!
      urlComponents.queryItems = [URLQueryItem(name: "ll", value: "\(coords.latitude),\(coords.longitude)")]
      if let url = urlComponents.url {
        open(url)
      }
    }
  }

  static func open(_ url: URL) {
#if canImport(UIKit)
    UIApplication.shared.open(url)
#else
    NSWorkspace.shared.open(url)
#endif
  }
}
