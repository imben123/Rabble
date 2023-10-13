//
//  AccountsWrapperView.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

struct AccountsWrapperView: View {

  @State private var currentAccount: User? = AccountsController.shared.users.first

  var repository: Repository? {
    guard let currentAccount else {
      return nil
    }
    let userDefaults = UserDefaults.defaultsForAccount(accountID: currentAccount.id)
    userDefaults.setValue(currentAccount.userToken, forKey: "userToken")
    return Repository(keyValueStore: userDefaults)
  }

  var body: some View {
    NavigationView {
      LoadEventsView()
        .id(currentAccount)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          if let currentAccount {
            ToolbarItem(placement: .topBarLeading) {
              Menu(content: {
                ForEach(AccountsController.shared.users, id: \.id) { user in
                  Button(action: { self.currentAccount = user }) {
                    Text(user.username)
                  }
                }
              }, label: {
                UserIcon(user: currentAccount, size: 35)
              })
            }
          }
          ToolbarItem(placement: .principal) {
            Text("Rabble")
          }
        }
        .environmentObject(repository!)
    }
  }
}
