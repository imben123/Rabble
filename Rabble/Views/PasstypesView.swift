//
//  PasstypesView.swift
//  Rabble
//
//  Created by Ben Davis on 11/10/2023.
//

import SwiftUI

struct PasstypesView: View {
  let passtypes: [Passtype]
  var body: some View {
    ScrollView {
      VStack {
        ForEach(passtypes, id: \.id) { passtype in
          Text(passtype.title)
        }
      }
    }
  }
}

#Preview {
  PasstypesView(passtypes: EventPasses.example.availablePasses)
}
