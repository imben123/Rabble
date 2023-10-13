//
//  UserDefaults+Accounts.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus

extension UserDefaults {
  static func defaultsForAccount(accountID: String) -> UserDefaults {
    let bundleID = Bundle.main.bundleIdentifier ?? ""
    return UserDefaults(suiteName: "\(bundleID).\(accountID)")!
  }
}
