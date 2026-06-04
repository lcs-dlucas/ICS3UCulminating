import SwiftUI

// MARK: - HandView
/// Displays a stack of cards using a ZStack with an offset to show "peeking" cards.
struct HandView: View {
    
    // MARK: - Stored properties
    
    let cards: [Card]
    private let maxVisibleCards = 8
    
    // MARK: - Computed properties
    
    /// Returns the subset of cards to be displayed (last 8)
    private var displayedCards: [Card] {
        if cards.count > maxVisibleCards {
            var result: [Card] = []
            let startIndex = cards.count - maxVisibleCards
            for i in startIndex..<cards.count {
                result.append(cards[i])
            }
            return result
        }
        return cards
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if cards.isEmpty {
                // Placeholder when no cards are drawn
                CardView(card: nil)
            } else {
                // Iterate through displayed cards and stack them
                ForEach(0..<displayedCards.count, id: \.self) { index in
                    CardView(card: displayedCards[index])
                        // Offset each card so the top peeks out
                        .offset(y: CGFloat(index) * -30)
                        .shadow(radius: 2)
                }
            }
        }
        // Add padding to account for the upward offset of stacked cards
        .padding(.top, CGFloat(displayedCards.count > 0 ? (displayedCards.count - 1) * 30 : 0))
    }
}

#Preview {
    VStack {
        HandView(cards: [
            Card(rank: .ace, suit: .spades),
            Card(rank: .king, suit: .hearts),
            Card(rank: .ten, suit: .diamonds)
        ])
        .padding()
    }
}
