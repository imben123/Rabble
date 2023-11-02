//
//  RoundedButtonStyle.swift
//  Rabble
//
//  Created by Ben Davis on 11/10/2023.
//

import SwiftUI

struct RoundedButton<Content: View>: View {
  let action: () -> Void
  let label: () -> Content

  init(action: @escaping () -> Void,
       @ViewBuilder label: @escaping () -> Content) {
    self.action = action
    self.label = label
  }

  var body: some View {
    Button(action: action, label: label)
      .buttonStyle(.roundedButtonStyle)
  }
}

struct RoundedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, 12)
      .padding(.vertical, 4)
      .background(RoundedRectangle(cornerRadius: 5).stroke())
      .foregroundColor(.accentColor)
      .opacity(configuration.isPressed ? 0.6 : 1)
  }
}

extension ButtonStyle where Self == RoundedButtonStyle {
  static var roundedButtonStyle: RoundedButtonStyle {
    RoundedButtonStyle()
  }
}
