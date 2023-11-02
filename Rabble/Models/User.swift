//
//  User.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import Foundation
import FoundationPlus

struct UserRaw: Model {
  let UserID: String
  let Firstname: String?
  let Lastname: String?
  let Username: String?
  let Image: String?
  let StripeCustomer: String?
  let UserIdent: String
}

struct User: Model {
  let id: String
  let firstName: String
  let lastName: String?
  let username: String
  let imageID: String?
  let stripeCustomerID: String?
  let userToken: String

  var imageURL: URL? {
    guard let imageID = imageID, imageID != "" else {
      return nil
    }
    return URL(string: "https://makesweat.com/userfiles/filethumbs/\(imageID)_256.jpg")
  }

  init(raw: UserRaw) {
    self.id = raw.UserID
    self.firstName = raw.Firstname ?? raw.Username ?? ""
    self.lastName = raw.Lastname
    self.username = raw.Username ?? raw.Firstname ?? ""
    self.imageID = raw.Image
    self.stripeCustomerID = raw.StripeCustomer
    self.userToken = raw.UserIdent
  }
}

