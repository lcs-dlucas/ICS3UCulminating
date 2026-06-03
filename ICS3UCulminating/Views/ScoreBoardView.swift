import SwiftUI

// MARK: - ScoreBoardView
/// Displays the current state of the game: deck counts and round scores.
struct ScoreBoardView: View {
    
    // MARK: - Stored properties
    
    let viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Player Stats
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
            
            // War Pile Info
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
            
            // CPU Stats
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
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 2)
    }
}

#Preview {
    ScoreBoardView(viewModel: GameViewModel())
        .padding()
}
