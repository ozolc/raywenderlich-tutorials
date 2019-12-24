//
//  WelcomeView.swift
//  Kuchi
//
//  Created by Maksim Nosov on 21.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            WelcomeBackgroundImage()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
