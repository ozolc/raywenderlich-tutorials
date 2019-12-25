//
//  WelcomeView.swift
//  Kuchi
//
//  Created by Maksim Nosov on 21.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  @EnvironmentObject var userManager: UserManager
  @EnvironmentObject var challengesViewModel: ChallengesViewModel
  @State var showHome = false
  
  @ViewBuilder
  var body: some View {
//    if showHome {
      PracticeView(challengeTest: $challengesViewModel.currentChallenge, userName: $userManager.profile.name)
    } else {
    VStack {
      Text("Hi, \(userManager.profile.name)")

      WelcomeMessageView()
      
      Button(action: {
        self.showHome = true
      }, label: {
        HStack {
          Image(systemName: "play")
          Text("Start")
        }
      })
    }
      .background(WelcomeBackgroundImage())
    }
  }
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
      .environmentObject(UserManager())
  }
}
#endif
