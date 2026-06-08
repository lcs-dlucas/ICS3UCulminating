import Foundation

// MARK: - RoundResult
/// An enumeration used to signify the outcome of a single round.
/// This acts as a clear signal between the logic layer and the visual layer.
enum RoundResult {
    case playerWin // Player had a higher round score.
    case cpuWin    // CPU had a higher round score.
    case tie       // Both players had identical scores (triggers War Pile).
    
    // MARK: - Computed properties
    
    /// Returns a localized victory/defeat message for display in the feedback area.
    var message: String {
        switch self {
        case .playerWin: return "Player wins the round!"
        case .cpuWin: return "CPU wins the round!"
        case .tie: return "It's a Tie! Moving to War Pile."
        }
    }
}
