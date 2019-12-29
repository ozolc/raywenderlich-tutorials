//
//  LearnView.swift
//  Kuchi
//
//  Created by Maksim Nosov on 28.12.2019.
//  Copyright © 2019 Omnijar. All rights reserved.
//

import SwiftUI

struct LearnView: View {
    @ObservedObject private var learningStore = LearningStore()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Swipe left if you remembered"
                + "\nSwipe right if you didn’t")
                .font(.headline)
            DeckView(onMemorized: { self.learningStore.score += 1}, deck: learningStore.deck)
            Spacer()
            Text("Remembered \(self.learningStore.score)"
              + "/\(self.learningStore.deck.cards.count)")
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
