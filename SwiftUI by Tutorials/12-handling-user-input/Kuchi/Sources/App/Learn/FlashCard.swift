//
//  FlashCard.swift
//  Kuchi
//
//  Created by Maksim Nosov on 28.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Learning
import Foundation

struct FlashCard {
    var isActive = true
    var card: WordCard
    var id = UUID()
}
