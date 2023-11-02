//
//  Timestamp+UpdatedAt.swift
//  Rabble
//
//  Created by Ben Davis on 16/10/2023.
//

import Foundation
import Time

extension Timestamp {
  private static let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.timeZone = .autoupdatingCurrent
    result.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return result
  }()

  var updatedAtString: String {
    Self.dateFormatter.string(from: date)
  }
}
