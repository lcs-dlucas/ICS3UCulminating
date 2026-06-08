import Foundation

// MARK: - Card
/// A type-safe and identifiable representation of a single playing card.
/// Conforms to 'Identifiable' to work with SwiftUI lists and 'Equatable' for comparisons.
struct Card: Identifiable, Equatable {
    
    // MARK: - Stored properties
    
    // Unique identifier for each card instance, required by Identifiable.
    let id: UUID = UUID()
    
    // The rank (value) of the card (e.g., Ace, King, Two).
    let rank: Rank
    
    // The suit of the card (Hearts, Diamonds, Clubs, Spades).
    let suit: Suit
    
    // MARK: - Computed properties
    
    /// Returns a human-readable description (e.g., "Ace of Spades").
    var description: String {
        return "\(rank.displayName) of \(suit.rawValue)"
    }
    
    // MARK: - Functions
    
    /// A static factory method that generates a complete 52-card deck.
    /// Returns: An array of Card objects.
    static func createFullDeck() -> [Card] {
        // Initialize an empty array to hold the cards.
        var deck: [Card] = []
        
        // Loop through every suit in the Suit enum.
        for suit in Suit.allCases {
            // Loop through every rank in the Rank enum.
            for rank in Rank.allCases {
                // Create a new Card instance with the current suit and rank.
                let newCard = Card(rank: rank, suit: suit)
                // Append the card to our deck array.
                deck.append(newCard)
            }
        }
        
        // Return the finished array.
        return deck
    }
    
    // MARK: - Equatable
    
    /// Implementation of the Equatable protocol.
    /// Allows us to use '==' to compare two cards.
    static func == (lhs: Card, rhs: Card) -> Bool {
        // Two cards are equal if they have the same rank AND the same suit.
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
}
