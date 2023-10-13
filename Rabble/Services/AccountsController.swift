//
//  AccountsController.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus

final class AccountsController {
  static let shared = AccountsController()

  @UserDefaultsStored(key: "users")
  var users: [User] = User.examples
}
