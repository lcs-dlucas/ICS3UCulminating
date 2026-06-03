import Foundation

// MARK: - RoundResult
/// Tracks the outcome of a single round of Higher or Lower War.
enum RoundResult {
    case playerWin
    case cpuWin
    case tie
    
    // MARK: - Computed properties
    
    /// Returns a message for display in the UI.
    var message: String {
        switch self {
        case .playerWin: return "Player wins the round!"
        case .cpuWin: return "CPU wins the round!"
        case .tie: return "It's a Tie! Moving to War Pile."
        }
    }
}
