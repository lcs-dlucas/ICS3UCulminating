import Foundation

// MARK: - Rank
/// Represents the face value of a card. 
/// Ace is assigned 14 to act as the highest card.
enum Rank: Int, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11
    case queen = 12
    case king = 13
    case ace = 14

    // MARK: - Computed properties
    
    /// Returns a user-friendly string for the rank.
    var displayName: String {
        switch self {
        case .ace: return "Ace"
        case .king: return "King"
        case .queen: return "Queen"
        case .jack: return "Jack"
        default: return String(self.rawValue)
        }
    }
}
