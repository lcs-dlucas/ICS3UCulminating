import SwiftUI

// MARK: - GameView
/// The main view container for the "Higher or Lower War" game.
struct GameView: View {
    
    // MARK: - Stored properties
    
    @State private var viewModel = GameViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // 1. Header & Scoreboard
                VStack(spacing: 8) {
                    Text("Higher or Lower War")
                        .font(.largeTitle)
                        .bold()
                    
                    ScoreBoardView(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 2. Play Area (Card Comparison)
                HStack(spacing: 30) {
                    // Player Side
                    VStack {
                        Text("You")
                            .font(.subheadline)
                            .bold()
                        CardView(card: viewModel.playerCurrentCard)
                    }
                    
                    Text("VS")
                        .font(.title)
                        .italic()
                        .foregroundStyle(.secondary)
                    
                    // CPU Side
                    VStack {
                        Text("CPU")
                            .font(.subheadline)
                            .bold()
                        CardView(card: viewModel.cpuCurrentCard)
                    }
                }
                
                // 3. Feedback Message
                Text(viewModel.feedbackMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .animation(.default, value: viewModel.feedbackMessage)
                
                Spacer()
                
                // 4. Interaction Controls
                ControlButtonsView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    GameView()
}
