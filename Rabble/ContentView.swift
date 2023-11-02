//
//  ContentView.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    AccountsWrapperView()
      .environmentObject(AccountsController.shared)
  }
}
