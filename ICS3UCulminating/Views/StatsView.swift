import SwiftUI

// MARK: - StatsView
/// A simple list view that displays saved data from the StatsManager.
struct StatsView: View {
    
    // MARK: - Stored properties
    
    // The data object loaded from the JSON file.
    let stats: GameStats
    
    // Environment property to allow the view to close itself.
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                // SECTION 1: Lifetime Wins and Losses.
                Section("Win / Loss Record") {
                    HStack {
                        Label("Games Won", systemImage: "trophy.fill")
                            .foregroundStyle(.yellow)
                        Spacer()
                        Text("\(stats.gamesWon)")
                            .bold()
                    }
                    
                    HStack {
                        Label("Games Lost", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Spacer()
                        Text("\(stats.gamesLost)")
                            .bold()
                    }
                }
                
                // SECTION 2: Success metrics for the Higher/Lower guesses.
                Section("Guessing Accuracy") {
                    HStack {
                        Label("Total Guesses", systemImage: "number.circle.fill")
                            .foregroundStyle(.blue)
                        Spacer()
                        Text("\(stats.totalGuesses)")
                    }
                    
                    HStack {
                        Label("Accuracy Rate", systemImage: "percent")
                            .foregroundStyle(.green)
                        Spacer()
                        // Formats the double to 1 decimal place.
                        Text(String(format: "%.1f%%", stats.accuracyRate))
                            .bold()
                    }
                }
            }
            .navigationTitle("Game History")
            .toolbar {
                // Adds a 'Done' button to the top navigation bar.
                Button("Done") { dismiss() }
            }
        }
    }
}
