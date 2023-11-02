//
//  Color+SystemBackground.swift
//  Rabble
//
//  Created by Ben Davis on 17/10/2023.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

extension Color {
  static var systemBackground: Color {
#if canImport(UIKit)
    Color(.systemBackground)
#else
    Color(.clear)
#endif
  }
}
