//
//  RegisterView.swift
//  Kuchi
//
//  Created by Maksim Nosov on 24.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var keyboardHandler: KeyboardFollower
    
    init(keyboardHandler: KeyboardFollower) {
        self.keyboardHandler = keyboardHandler
    }
    
      var body: some View {
        VStack(content: {
          WelcomeMessageView()
          
          TextField("Type your name...", text: $userManager.profile.name)
            .bordered()

          HStack {
            Spacer()
            Text("\(userManager.profile.name.count)")
              .font(.caption)
              .foregroundColor(userManager.isUserNameValid() ? .green : .red)
              .padding(.trailing)
          }
          .padding(.bottom)


          HStack {
            Spacer()
          
            Toggle(isOn: $userManager.settings.rememberUser) {
              Text("Remember me")
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.gray)
            }
          }

          Button(action: self.registerUser) {
            HStack {
              Image(systemName: "checkmark")
                .resizable()
                .frame(width: 16, height: 16, alignment: .center)
              Text("OK")
                .font(.body)
                .bold()
            }
          }
          .bordered()
          .disabled(!userManager.isUserNameValid())
        })
          .padding(.bottom, keyboardHandler.keyboardHeight)
          .background(WelcomeBackgroundImage())
          .padding()
          .onAppear { self.keyboardHandler.subscribe() }
          .onDisappear { self.keyboardHandler.unsubscribe() }
      }
    }

struct RegisterView_Previews: PreviewProvider {
    static let user = UserManager(name: "Maksim")
    
    static var previews: some View {
        RegisterView(keyboardHandler: KeyboardFollower())
            .environmentObject(user)
    }
}

// MARK: - Event Handlers
extension RegisterView {
    func registerUser() {
        
        if userManager.settings.rememberUser {
            userManager.persistProfile()
        } else {
            userManager.clear()
        }
        
        userManager.persistSettings()
    }
}
