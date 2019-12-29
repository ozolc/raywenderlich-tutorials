//
//  LearningStore.swift
//  Kuchi
//
//  Created by Maksim Nosov on 29.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import Combine
import Languages
import Learning

final class LearningStore {

  // 1
  @Published var deck: FlashDeck

  // 2
  @Published var card: FlashCard

  // 3
  @Published var score = 0

  // 4
  init() {
    let deck = FlashDeck(from: DeckBuilder.learning.build())
    self.deck = deck
    self.card = FlashCard(
      card: WordCard(
        from: TranslatedWord(
          from: "",
          withPronunciation: "",
          andTranslation: "")))

    if let nextCard = self.getNextCard() {
      self.card = nextCard
    }
  }

  // 5
  func getNextCard() -> FlashCard? {
    if let nextCard = self.getLastCard() {
      self.card = nextCard
      self.deck.cards.removeLast()
    }

    return self.card
  }

  // 6
  func getLastCard() -> FlashCard? {
    if let lastCard = deck.cards.last {
      self.card = lastCard
      return self.card
    } else {
      return nil
    }
  }
}
