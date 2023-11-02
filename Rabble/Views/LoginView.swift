//
//  LoginView.swift
//  Rabble
//
//  Created by Ben Davis on 02/11/2023.
//

import SwiftUI

struct LoginView: View {

  @Environment(\.dismiss) private var dismiss

  @State private var email: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String?
  @State private var loading = false

  var onComplete: ((User) -> Void)?

  private var canLogIn: Bool {
    return !loading && isValidEmail(email) && password.count >= 2
  }

  var body: some View {
    ScrollView {
      Spacer().frame(height: 100)
      VStack {
        Image("RabbleLogo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200)
          .padding(.bottom, 20)

        VStack {
          InputFieldTitle(text: "Email")
          InputField(placeholder: "Please enter your email address", text: $email)
            .keyboardType(.emailAddress)
            .disabled(loading)

          InputFieldTitle(text: "Password")
          InputField(placeholder: "Password", text: $password, password: true)
            .disabled(loading)

          if let errorMessage {
            Text(errorMessage)
              .foregroundStyle(.red)
          }

          RoundedButton(action: login) {
            Text("Login")
              .frame(maxWidth: .infinity)
              .frame(height: 30)
          }
          .padding(.top, 12)
          .disabled(!canLogIn)

          Button("Cancel", action: { dismiss() })
            .foregroundColor(Color(.darkGray))
            .padding()
            .disabled(loading)

        }.padding(.horizontal, 28)
      }
    }
  }

  private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }

  private func login() {
    loading = true
    Task {
      do {
        let user = try await AccountsController.shared.login(email: self.email, password: self.password)
        dismiss()
        onComplete?(user)
      } catch let error {
        errorMessage = error.localizedDescription
      }
      loading = false
    }
  }
}

struct InputFieldTitle: View {
  let text: String
  var body: some View {
    HStack {
      Text(text)
        .font(.subheadline)
        .padding(.leading, 12)
      Spacer()
    }
  }
}

struct InputField: View {
  let placeholder: String
  let text: Binding<String>
  var password = false

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12).stroke()
      field()
        .frame(height: 44)
        .padding(.horizontal)
    }
    .frame(height: 44)
    .padding(.bottom, 12)
  }

  @ViewBuilder
  private func field() -> some View {
    if password {
      SecureField(placeholder, text: text)
    } else {
      TextField(placeholder, text: text)
    }
  }
}

#Preview {
  LoginView()
}
