//
//  EventPasses.swift
//  Rabble
//
//  Created by Ben Davis on 11/10/2023.
//

import Foundation
import FoundationPlus
import Time

struct EventPasses: Model {
  let passtypes: [Passtype]

  var availablePasses: [Passtype] {
    passtypes.filter(\.passIsValidForEvent).filter(\.passAvailable)
  }

  init(raw: EventPassesRaw) {
    self.passtypes = raw.passtypes.map(Passtype.init(raw:))
  }
}

struct EventPassesRaw: Model {
  let passtypes: [PasstypeRaw]
}

struct PasstypeRaw: Model {
  let PasstypeID: String
  let Title: String
  let Notes: String
  let Cost: String
  let cur_symb: String
  let cur_iso: String
  let DefCredit: String // "1" number of "passes" in pack
  let Duration: String // "30" in days
  let PassID: String
  let StartDate: String? // "2023-09-30"
  let UserID: String? // "29669"
  let ExpiryDate: String? // "2023-10-29"
  let Valid: String // "0" invalid "1" valid?
  let Numused: String //"0",
  let etopID: String
  let Recurs: String //"0",
  let utoeID: String // "303706",
  let utoe_PassID: String // "87903",
}

struct Passtype: Model {
  let id: String
  let passID: Int
  let title: String
  let notes: String
  let cost: Currency
  let recurring: Bool
  let numberOfPassesInPack: Int?
  let numberUsed: Int
  let startDate: CalendarDate?
  let expiryDate: CalendarDate?

  let passAvailable: Bool
  let passIsValidForEvent: Bool
  let passUsedForEvent: Bool

  init(raw: PasstypeRaw) {
    self.id = raw.PasstypeID
    self.title = raw.Title
    self.notes = raw.Notes
    let decimalCost = Double(raw.Cost) ?? 0
    let currencyValue = CurrencyValue(rawValue: Int(decimalCost * 100)) ?? 0
    self.cost = Currency(value: currencyValue, type: raw.cur_iso)
    self.recurring = raw.Recurs == "1"
    self.numberOfPassesInPack = raw.DefCredit == "0" ? nil : Int(raw.DefCredit)
    self.numberUsed = Int(raw.Numused) ?? 0
    self.startDate = raw.StartDate != nil ? try? CalendarDate(iso8601String: raw.StartDate!) : nil
    self.expiryDate = raw.ExpiryDate != nil ? try? CalendarDate(iso8601String: raw.ExpiryDate!) : nil

    let passID = Int(raw.PassID) ?? 0
    let etopID = Int(raw.etopID) ?? 0
    let utoe_PassID = Int(raw.utoe_PassID) ?? 0
    self.passID = passID
    self.passAvailable = passID > 0
    self.passIsValidForEvent = etopID > 0
    self.passUsedForEvent = utoe_PassID == passID
  }
}
