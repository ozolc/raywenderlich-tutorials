//
//  DeckView.swift
//  Kuchi
//
//  Created by Maksim Nosov on 29.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject private var deck: FlashDeck
    
    private let onMemorized: () -> Void
    
    init(onMemorized: @escaping () -> Void, deck: FlashDeck) {
        self.onMemorized = onMemorized
        self.deck = deck
    }
    
    var body: some View {
        ZStack {
            ForEach(deck.cards.filter { $0.isActive }) { card in
                self.getCardView(for: card)
            }
        }
    }
    
    private func getCardView(for card: FlashCard) -> CardView {
        let activeCards = deck.cards.filter { $0.isActive == true }
        if let lastCard = activeCards.last {
            if lastCard == card {
                return createCardView(for: card)
            }
        }
        
        let view = createCardView(for: card)
        
        return view
    }
    
    private func createCardView(for card: FlashCard) -> CardView {
        let view = CardView(card, onDrag: { drag, direction in
            if direction == .left {
                self.onMemorized()
            }
        })
        
        return view
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(onMemorized: {}, deck: LearningStore().deck)
    }
}
