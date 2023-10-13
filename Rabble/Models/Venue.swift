//
//  Venue.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus
import CoreLocation
import Contacts
import MapKit
import AddressBook

struct Venue: Model {
  let name: String
  let address: String?
  let postcode: String?
  let coords: CLLocationCoordinate2D?

  var fullAddressString: String? {
    if let address, let postcode {
      return "\(address), \(postcode)"
    } else if let address {
      return address
    } else if let postcode {
      return postcode
    }
    return nil
  }

  var placemark: MKPlacemark? {
    guard let coords = coords else {
      return nil
    }
    let address = [
      CNPostalAddressStreetKey: address,
      CNPostalAddressPostalCodeKey: postcode,
      CNPostalAddressISOCountryCodeKey: "GB"
    ].compactMapValues { $0 }

    return MKPlacemark(coordinate: coords, addressDictionary: address)
  }
}

extension CLLocationCoordinate2D: Model {

  public static func == (_ lhs: CLLocationCoordinate2D, _ rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.longitude == rhs.longitude && rhs.latitude == rhs.latitude
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }

  private enum CodingKeys: CodingKey {
    case latitude, longitude
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(longitude, forKey: .longitude)
    try container.encode(latitude, forKey: .latitude)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
    self.init(latitude: latitude, longitude: longitude)
  }

  init?(latitude: String?, longitude: String?) {
    guard let latitudeString = latitude,
          let longitudeString = longitude,
          let lat = CLLocationDegrees(latitudeString),
          let lon = CLLocationDegrees(longitudeString) else {
      return nil
    }
    self.init(latitude: lat, longitude: lon)
  }
}
