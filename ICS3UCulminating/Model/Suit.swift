import Foundation

// MARK: - Suit
/// An enumeration representing the four standard suits of a playing card deck.
/// Conforms to String to provide raw values and CaseIterable for easy looping.
enum Suit: String, CaseIterable {
    case hearts = "Hearts"     // Red suit
    case diamonds = "Diamonds" // Red suit
    case clubs = "Clubs"       // Black suit
    case spades = "Spades"     // Black suit
}
