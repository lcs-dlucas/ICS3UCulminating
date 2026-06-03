import Foundation

// MARK: - Card
/// A type-safe representation of a playing card.
struct Card: Identifiable, Equatable {
    
    // MARK: - Stored properties
    
    let id: UUID = UUID()
    let rank: Rank
    let suit: Suit
    
    // MARK: - Computed properties
    
    /// Returns a human-readable description (e.g., "Ace of Spades").
    var description: String {
        return "\(rank.displayName) of \(suit.rawValue)"
    }
    
    // MARK: - Functions
    
    /// Generates a standard 52-card deck.
    /// Uses explicit loops to maintain readability for students.
    static func createFullDeck() -> [Card] {
        var deck: [Card] = []
        
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let newCard = Card(rank: rank, suit: suit)
                deck.append(newCard)
            }
        }
        
        return deck
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
}
