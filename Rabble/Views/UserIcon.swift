//
//  UserIcon.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

protocol UserType {
  var initials: String { get }
  var imageURL: URL? { get }
}

extension User: UserType {
  var initials: String {
    if let lastName, firstName.count > 1, lastName.count > 0 {
      return "\(firstName.first!)\(lastName.first!)"
    } else if !username.isEmpty {
      let components = username.split(separator: " ")
      if components.count > 1 {
        return "\(components.first!.first!)\(components.last!.first!)"
      } else if components.count > 0 {
        return "\(components.first!.first!)"
      } else {
        return "??"
      }
    } else if !firstName.isEmpty {
      return "\(firstName.first!)"
    } else {
      return "??"
    }
  }
}
extension Attendee: UserType {
  var initials: String {
    let components = name.split(separator: " ")
    if components.count > 1 {
      return "\(components.first!.first!)\(components.last!.first!)"
    } else if components.count > 0 {
      return "\(components.first!.first!)"
    } else {
      return "??"
    }
  }
}

struct UserIcon: View {
  let user: UserType
  var size: CGFloat = 65
  var body: some View {
    if let imageURL = user.imageURL {
      UserImageIcon(url: imageURL, size: size)
    } else {
      UserInitialIcon(name: user.initials, size: size)
    }
  }
}

struct UserImageIcon: View {
  let url: URL?
  var size: CGFloat = 65
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.accentColor)
        .frame(height: size)
      AsyncImage(url: url) {
        image in image.resizable().aspectRatio(contentMode: .fill)
      } placeholder: {
        Color(.lightGray)
      }
      .frame(width: size * (60/65))
      .clipShape(Circle())
      .frame(height: size * (60/65))
    }
  }
}

struct UserInitialIcon: View {
  let name: String
  var size: CGFloat = 65
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.accentColor)
        .frame(height: size)
      Text(name)
        .font(.system(size: size * (26/65)))
        .foregroundColor(.white)
    }
  }
}

#Preview {
  VStack {
    UserIcon(user: User.examples[0])
    UserIcon(user: User.examples[1])
    UserIcon(user: User.examples[0], size: 25)
    UserIcon(user: User.examples[1], size: 25)
  }
}
