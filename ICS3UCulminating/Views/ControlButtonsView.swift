import SwiftUI

// MARK: - ControlButtonsView
/// Contains the buttons for user interaction: guessing and starting rounds.
struct ControlButtonsView: View {
    
    // MARK: - Stored properties
    
    let viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isPlayerTurn {
                // Higher / Lower Buttons
                HStack(spacing: 20) {
                    Button {
                        viewModel.playerGuess(isHigher: true)
                    } label: {
                        Label("Higher", systemImage: "arrow.up.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        viewModel.playerGuess(isHigher: false)
                    } label: {
                        Label("Lower", systemImage: "arrow.down.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .font(.headline)
            } else {
                // Deal / Next Round Button
                Button {
                    viewModel.startRound()
                } label: {
                    Text(viewModel.isRoundOver ? "Start Next Round" : "Deal Cards")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    VStack {
        ControlButtonsView(viewModel: GameViewModel())
    }
    .padding()
}
