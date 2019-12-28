//
//  FlashCard+Equatable.swift
//  Kuchi
//
//  Created by Maksim Nosov on 28.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Foundation

extension FlashCard: Equatable {
  static func == (lhs: FlashCard, rhs: FlashCard) -> Bool {
    return lhs.card.word.original == rhs.card.word.original
      && lhs.card.word.translation == rhs.card.word.translation
  }
}
