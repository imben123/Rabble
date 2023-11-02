//
//  AccountView.swift
//  Rabble
//
//  Created by Ben Davis on 02/11/2023.
//

import SwiftUI

struct AccountView: View {
  
  let user: User
  let switchUser: (User?) -> Void

  @State private var showLogin = false

  @EnvironmentObject private var accountsController: AccountsController
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button(action: { dismiss() }, label: {
          Image(systemName: "xmark.circle.fill")
            .font(.system(size: 28))
            .frame(width: 44)
            .padding(16)
        })
        .accentColor(Color(.lightGray))
      }
      UserIcon(user: user, size: 150)
        .padding(40)
      Text(user.fullName).font(.title)
      VStack(spacing: 20) {
        RoundedButton(action: { showLogin = true }) {
          Text("Add Account")
        }
        RoundedButton(action: logout) {
          Text("Logout")
        }
      }
      Spacer()
    }
    .sheet(isPresented: $showLogin, content: {
      LoginView(onComplete: { user in
        switchUser(user)
        dismiss()
      })
    })
  }

  private func logout() {
    accountsController.logout(user: user)
    switchUser(nil)
    dismiss()
  }
}

#Preview {
  AccountView(user: User.examples[0], switchUser: { _ in })
}
