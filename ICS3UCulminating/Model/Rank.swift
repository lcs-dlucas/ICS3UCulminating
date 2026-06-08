import Foundation

// MARK: - Rank
/// An enumeration representing the face value of a playing card.
/// The raw value (Int) is used as the numeric score in the game logic.
enum Rank: Int, CaseIterable {
    // Basic number cards
    case two = 2, three, four, five, six, seven, eight, nine, ten
    
    // Face cards with higher values
    case jack = 11
    case queen = 12
    case king = 13
    
    // Ace is assigned 14 to ensure it wins against all other cards.
    case ace = 14

    // MARK: - Computed properties
    
    /// Returns a user-friendly string for the rank (e.g., "Jack" instead of "11").
    var displayName: String {
        switch self {
        case .ace: return "Ace"
        case .king: return "King"
        case .queen: return "Queen"
        case .jack: return "Jack"
        default: 
            // For 2-10, just return the number as a string.
            return String(self.rawValue)
        }
    }
}
