//
//  Currency.swift
//  Rabble
//
//  Created by Ben Davis on 11/10/2023.
//

import Foundation
import FoundationPlus

struct Currency: Model {
  let value: CurrencyValue
  let type: String
}

struct CurrencyValue: RawRepresentable, Model {
  var rawValue: Int
  init?(rawValue: Int) {
    self.rawValue = rawValue
  }
}

extension CurrencyValue: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.rawValue = value
  }
}
