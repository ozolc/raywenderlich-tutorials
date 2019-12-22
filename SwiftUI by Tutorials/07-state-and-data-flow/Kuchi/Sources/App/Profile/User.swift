//
//  User.swift
//  Kuchi
//
//  Created by Maksim Nosov on 22.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Combine

final internal class User {
    
    @Published var isRegistered: Bool = false
    
    let willChange = PassthroughSubject<User, Never>()
    
    var profile: Profile = Profile() {
        willSet {
            willChange.send(self)
        }
    }
    
    init(name: String) {
        self.profile.name = name
    }
    
    init() { }
}
