//
//  AccountsController.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus

final class AccountsController: ObservableObject {
  
  static let shared = AccountsController()

  @UserDefaultsStored(key: "users")
  var users: [User] = [] {
    willSet {
      self.objectWillChange.send()
    }
  }

  func login(email: String, password: String) async throws {
    let api = RabbleAPI()
    let userRaw = try await api.login(email: email, password: password)
    let user = User(raw: userRaw)
    await MainActor.run {
      if let existingIndex = users.firstIndex(where: { $0.id == user.id }) {
        users[existingIndex] = user
      } else {
        users.append(user)
      }
    }
  }
}
