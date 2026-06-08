import SwiftUI

// MARK: - ControlButtonsView
/// Manages the primary interaction buttons based on the game's current state.
struct ControlButtonsView: View {
    
    // MARK: - Stored properties
    
    let viewModel: GameViewModel
    
    // Closure to trigger showing the stats sheet in the parent view.
    var onShowStats: (() -> Void)? = nil
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            // STATE 1: Player is currently making a move.
            if viewModel.isPlayerTurn {
                HStack(spacing: 20) {
                    // GUESS HIGHER Button
                    Button {
                        viewModel.playerGuess(isHigher: true)
                    } label: {
                        Label("Higher", systemImage: "arrow.up.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            // Change color to gray if the CPU is thinking to show it's disabled.
                            .background(viewModel.isCPUThinking ? .gray : .green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isCPUThinking)
                    
                    // GUESS LOWER Button
                    Button {
                        viewModel.playerGuess(isHigher: false)
                    } label: {
                        Label("Lower", systemImage: "arrow.down.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isCPUThinking ? .gray : .red)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isCPUThinking)
                }
                .font(.headline)
            } 
            // STATE 2: Waiting to start a new round or game.
            else {
                HStack(spacing: 12) {
                    // ACTION Button (Deal / Next Round)
                    Button {
                        viewModel.startRound()
                    } label: {
                        Text(viewModel.isRoundOver ? "Start Next Round" : "Deal Cards")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isCPUThinking ? .gray : .blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isCPUThinking)
                    
                    // HISTORY Button (Opens stats)
                    Button {
                        onShowStats?()
                    } label: {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                            .font(.title2)
                            .padding()
                            .background(viewModel.isCPUThinking ? .gray : .orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isCPUThinking)
                }
            }
        }
    }
}
