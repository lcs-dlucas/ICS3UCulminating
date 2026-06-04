import SwiftUI

// MARK: - GameView
/// The main view container for the "Higher or Lower War" game.
struct GameView: View {
    
    // MARK: - Stored properties
    
    @State private var viewModel = GameViewModel()
    @State private var showRules = false
    
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
                    HStack {
                        Spacer()
                        Text("Higher or Lower War")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button {
                            showRules = true
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    ScoreBoardView(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 2. Play Area (Card Comparison)
                HStack(alignment: .bottom, spacing: 30) {
                    // Player Side
                    VStack {
                        Text("You (\(viewModel.playerRoundScore))")
                            .font(.headline)
                            .bold()
                        HandView(cards: viewModel.playerHand)
                    }
                    
                    Text("VS")
                        .font(.title)
                        .italic()
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 60)
                    
                    // CPU Side
                    VStack {
                        Text("CPU (\(viewModel.cpuRoundScore))")
                            .font(.headline)
                            .bold()
                        HandView(cards: viewModel.cpuHand)
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
        .sheet(isPresented: $showRules) {
            RulesView()
        }
    }
}

// MARK: - RulesView
struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("How to Play")
                        .font(.title)
                        .bold()
                    
                    Text("1. Each player starts with 26 cards.")
                    Text("2. A baseline card is revealed for both players.")
                    Text("3. On your turn, guess if the next card will be HIGHER or LOWER than the current one.")
                    Text("4. Correct guesses add the card's value to your score. The new card becomes the baseline.")
                    Text("5. A wrong guess ends your turn immediately.")
                    Text("6. The CPU then takes its turn using the same rules.")
                    Text("7. The highest total score wins ALL cards used in the round.")
                    Text("8. If it's a TIE, cards go to the WAR PILE for the next winner!")
                }
                .padding()
            }
            .navigationTitle("Game Rules")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    GameView()
}
