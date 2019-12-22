//
//  Profile.swift
//  Kuchi
//
//  Created by Maksim Nosov on 22.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Foundation

// Profile of the learner using the app.

struct Profile {
    // (Selected) name of the learner.
    var name: String
    
    // Initializes a new `Profile` with an empty `name`.
    init() {
        self.name = ""
    }
}
