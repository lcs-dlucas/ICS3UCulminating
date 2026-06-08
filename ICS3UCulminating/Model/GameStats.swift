import Foundation

// MARK: - GameStats
/// A Codable structure that stores the player's lifetime performance data.
/// Codable allows this struct to be easily converted to and from JSON.
struct GameStats: Codable {
    
    // MARK: - Stored properties
    
    var gamesWon: Int = 0     // Total number of full games won.
    var gamesLost: Int = 0    // Total number of full games lost.
    var totalGuesses: Int = 0 // Total "Higher/Lower" guesses made.
    var correctGuesses: Int = 0 // Number of successful guesses.
    
    // MARK: - Computed properties
    
    /// Calculates the percentage of guesses that were correct.
    /// Returns 0.0 if no guesses have been made to avoid division by zero.
    var accuracyRate: Double {
        guard totalGuesses > 0 else { return 0.0 }
        // Convert to Double to perform decimal division, then multiply by 100 for percentage.
        return (Double(correctGuesses) / Double(totalGuesses)) * 100.0
    }
}

// MARK: - StatsManager
/// A singleton utility class that manages file I/O operations for game statistics.
class StatsManager {
    
    // The shared singleton instance used throughout the app.
    static let shared = StatsManager()
    
    // The name of the file where stats are stored on the device.
    private let fileName = "game_stats.json"
    
    // Private initializer ensures no other instances can be created.
    private init() {}
    
    // MARK: - File Path Logic
    
    /// Finds the unique URL for the app's 'Documents' directory on the user's device.
    private func getFileURL() -> URL? {
        // Look for the document directory in the user's domain.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Append our specific file name to that folder path.
        return paths.first?.appendingPathComponent(fileName)
    }
    
    // MARK: - Persistence Functions
    
    /// Encodes a GameStats object into JSON and writes it to the local file system.
    func save(stats: GameStats) {
        guard let url = getFileURL() else { return }
        
        do {
            // Transform the struct into raw JSON data.
            let data = try JSONEncoder().encode(stats)
            // Write that data to the file path.
            try data.write(to: url)
        } catch {
            print("Failed to save stats: \(error.localizedDescription)")
        }
    }
    
    /// Reads the JSON file from the local file system and decodes it into a GameStats object.
    func load() -> GameStats {
        // Attempt to find the file and read its contents.
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              // Attempt to decode the JSON data back into our struct.
              let stats = try? JSONDecoder().decode(GameStats.self, from: data) else {
            // If the file doesn't exist yet, return a fresh set of empty stats.
            return GameStats()
        }
        return stats
    }
}
