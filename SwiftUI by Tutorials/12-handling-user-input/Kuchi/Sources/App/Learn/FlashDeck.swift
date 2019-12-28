//
//  FlashDeck.swift
//  Kuchi
//
//  Created by Maksim Nosov on 28.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Foundation
import Learning

final internal class FlashDeck {
    @Published var cards: [FlashCard]
    
    init(from words: [WordCard]) {
        self.cards = words.map({
            FlashCard(card: $0)
        })
    }
}
