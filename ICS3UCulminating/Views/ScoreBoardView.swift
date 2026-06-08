import SwiftUI

// MARK: - ScoreBoardView
/// A dashboard component that displays deck counts and round scores.
struct ScoreBoardView: View {
    
    // MARK: - Stored properties
    
    // References the ViewModel to observe changes in deck counts and scores.
    let viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // COLUMN 1: Player's overall deck count and current round score.
            VStack(alignment: .leading) {
                Text("Player")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Deck: \(viewModel.playerDeck.count)")
                    .font(.headline)
                Text("Score: \(viewModel.playerRoundScore)")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.blue)
            }
            
            Spacer()
            
            // COLUMN 2: The War Pile (only visible when there are cards in limbo).
            if viewModel.warPile.count > 0 {
                VStack {
                    Text("War Pile")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text("\(viewModel.warPile.count)")
                        .font(.title3)
                        .bold()
                }
                .padding(8)
                .background(.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
            // COLUMN 3: CPU's overall deck count and current round score.
            VStack(alignment: .trailing) {
                Text("CPU")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Deck: \(viewModel.cpuDeck.count)")
                    .font(.headline)
                Text("Score: \(viewModel.cpuRoundScore)")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.orange)
            }
        }
        .padding()
        // Use ultraThinMaterial for a modern "glassmorphism" look.
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 2)
    }
}
