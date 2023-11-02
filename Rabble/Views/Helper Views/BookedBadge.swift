//
//  BookedBadge.swift
//  Rabble
//
//  Created by Ben Davis on 16/10/2023.
//

import SwiftUI

struct BookedBadge: View {
  var body: some View {
    Text("Booked")
      .font(.caption)
      .padding(.horizontal, 4)
      .padding(.vertical, 2)
      .background(Color.rabbleOrange)
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .foregroundColor(.white)
      .padding(.top, 2)
  }
}

#Preview {
  BookedBadge()
}
