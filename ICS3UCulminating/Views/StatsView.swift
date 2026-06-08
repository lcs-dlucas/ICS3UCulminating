import SwiftUI

// MARK: - StatsView
/// Displays the player's lifetime statistics.
struct StatsView: View {
    
    // MARK: - Stored properties
    
    let stats: GameStats
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
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
                        Text(String(format: "%.1f%%", stats.accuracyRate))
                            .bold()
                    }
                }
            }
            .navigationTitle("Game History")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    StatsView(stats: GameStats(gamesWon: 5, gamesLost: 2, totalGuesses: 100, correctGuesses: 75))
}
