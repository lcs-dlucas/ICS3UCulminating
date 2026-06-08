import SwiftUI

// MARK: - HandView
/// Displays a stack of cards using a ZStack with an offset to show "peeking" cards.
struct HandView: View {
    
    // MARK: - Stored properties
    
    // The full list of cards that have been drawn this round.
    let cards: [Card]
    
    // A constant to prevent the UI from overflowing if the player draws many cards.
    private let maxVisibleCards = 8
    
    // MARK: - Computed properties
    
    /// Returns only the 8 most recent cards to keep the UI clean.
    private var displayedCards: [Card] {
        if cards.count > maxVisibleCards {
            var result: [Card] = []
            // Calculate the starting index to slice the array.
            let startIndex = cards.count - maxVisibleCards
            for i in startIndex..<cards.count {
                result.append(cards[i])
            }
            return result
        }
        // If 8 or fewer, show the whole array.
        return cards
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if cards.isEmpty {
                // Initial state: show an empty card placeholder.
                CardView(card: nil)
            } else {
                // Loop through the cards we want to display.
                ForEach(0..<displayedCards.count, id: \.self) { index in
                    CardView(card: displayedCards[index])
                        // Each subsequent card is shifted UPWARDS by 30 pixels.
                        // This allows the top of previous cards to "peek" out.
                        .offset(y: CGFloat(index) * -30)
                        // Add a shadow to create depth between the layers.
                        .shadow(radius: 2)
                        // transition ensures cards slide in gracefully.
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        // Add top padding equal to the cumulative offset so the stack doesn't clip.
        .padding(.top, CGFloat(displayedCards.count > 0 ? (displayedCards.count - 1) * 30 : 0))
    }
}
