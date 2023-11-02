//
//  AccountsWrapperView.swift
//  Rabble
//
//  Created by Ben Davis on 12/10/2023.
//

import SwiftUI

struct AccountsWrapperView: View {

  @EnvironmentObject private var accountsController: AccountsController
  @State private var currentAccount: User?
  @State private var showLogin = false
  @State private var showAccount = false

  var showLoginOrAccount: Binding<Bool> {
    Binding(get: { showLogin || showAccount }, set: { newValue in
      if newValue == false {
        showLogin = false
        showAccount = false
      }
    })
  }

  var currentUserOrFirst: User? {
    if let currentAccount {
      return currentAccount
    } else {
      return accountsController.users.first
    }
  }

  var repository: Repository {
    guard let currentAccount = currentUserOrFirst else {
      return Repository(keyValueStore: UserDefaults.standard)
    }
    let userDefaults = UserDefaults.defaultsForAccount(accountID: currentAccount.id)
    userDefaults.setValue(currentAccount.userToken, forKey: "userToken")
    return Repository(keyValueStore: userDefaults)
  }

  var body: some View {
    NavigationStack {
      LoadEventsView()
        .id(currentAccount)
        .navBarTitleDisplayMode(.inline)
        .toolbar {
          RabbleToolbarContent(currentAccount: $currentAccount,
                               showLogin: { showLogin = true },
                               showAccount: { showAccount = true })
        }
        .environmentObject(repository)
    }
    .sheet(isPresented: showLoginOrAccount, content: {
      if showLogin {
        LoginView()
      } else {
        AccountView(user: currentUserOrFirst!, switchUser: { user in
          currentAccount = user
        })
      }
    })
  }
}

struct RabbleToolbarContent: ToolbarContent {
  @Binding var currentAccount: User?
  let showLogin: () -> Void
  let showAccount: () -> Void
  @EnvironmentObject private var accountsController: AccountsController

  var currentUserOrFirst: User? {
    if let currentAccount {
      return currentAccount
    } else {
      return accountsController.users.first
    }
  }

  var loginText: String {
    currentUserOrFirst == nil ? "Login" : "Add Account"
  }

  var body: some ToolbarContent {
    if let currentUserOrFirst, accountsController.users.count > 1 {
      ToolbarItem(placement: .placementForUserSwitcher) {
        Menu(content: {
          ForEach(accountsController.users, id: \.id) { user in
            Button(action: { self.currentAccount = user }) {
              Text(user.username)
            }
          }
        }, label: {
          UserIcon(user: currentUserOrFirst, size: 35)
        })
      }
    }
    ToolbarItem(placement: .principal) {
      Text("Rabble")
    }
    if let currentUserOrFirst {
      ToolbarItem(placement: .placementForLogin) {
        Button(action: { showAccount() }, label: {
          if accountsController.users.count > 1 {
            Image(systemName: "gear")
          } else {
            UserIcon(user: currentUserOrFirst, size: 35)
          }
        })
      }
    } else {
      ToolbarItem(placement: .placementForLogin) {
        Button("Login", action: { showLogin() })
      }
    }
  }
}

enum NavigationBarItemTitleDisplayMode {
  case inline
}

extension ToolbarItemPlacement {
  static var placementForUserSwitcher: ToolbarItemPlacement {
#if os(macOS)
    return ToolbarItemPlacement.automatic
#else
    return .topBarLeading
#endif
  }

  static var placementForLogin: ToolbarItemPlacement {
#if os(macOS)
    return ToolbarItemPlacement.automatic
#else
    return .topBarTrailing
#endif
  }
}

extension View {
  func navBarTitleDisplayMode(_ mode: NavigationBarItemTitleDisplayMode) -> some View {
#if os(macOS)
    self
#else
    self.navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
#endif
  }
}
