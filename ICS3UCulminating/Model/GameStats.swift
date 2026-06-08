import Foundation

// MARK: - GameStats
/// A model to track the user's performance over time.
struct GameStats: Codable {
    
    // MARK: - Stored properties
    
    var gamesWon: Int = 0
    var gamesLost: Int = 0
    var totalGuesses: Int = 0
    var correctGuesses: Int = 0
    
    // MARK: - Computed properties
    
    /// Returns the percentage of correct guesses.
    var accuracyRate: Double {
        guard totalGuesses > 0 else { return 0.0 }
        return (Double(correctGuesses) / Double(totalGuesses)) * 100.0
    }
}

// MARK: - StatsManager
/// Handles saving and loading game statistics to the file system using JSON.
class StatsManager {
    
    static let shared = StatsManager()
    private let fileName = "game_stats.json"
    
    private init() {}
    
    /// Returns the URL for the stats file in the Documents directory.
    private func getFileURL() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first?.appendingPathComponent(fileName)
    }
    
    /// Saves stats to a JSON file.
    func save(stats: GameStats) {
        guard let url = getFileURL() else { return }
        
        do {
            let data = try JSONEncoder().encode(stats)
            try data.write(to: url)
        } catch {
            print("Failed to save stats: \(error.localizedDescription)")
        }
    }
    
    /// Loads stats from a JSON file.
    func load() -> GameStats {
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              let stats = try? JSONDecoder().decode(GameStats.self, from: data) else {
            return GameStats()
        }
        return stats
    }
}
