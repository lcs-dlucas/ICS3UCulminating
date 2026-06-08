import SwiftUI

// MARK: - GameView
/// The orchestrator of the entire UI, assembling subviews into a cohesive game screen.
struct GameView: View {
    
    // MARK: - Stored properties
    
    // Initializes the ViewModel which persists for the life of the view.
    @State private var viewModel = GameViewModel()
    
    // Local state to control when the Rules and Stats sheets appear.
    @State private var showRules = false
    @State private var showStats = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // LAYER 1: A subtle purple/blue gradient for the background.
            LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // LAYER 2: The primary layout stack.
            VStack(spacing: 25) {
                // 1. Header with Title and Help Button.
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Text("Higher or Lower War")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        // Rules toggle button.
                        Button {
                            showRules = true
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    // Display the dashboard panel.
                    ScoreBoardView(viewModel: viewModel)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 2. Play Area: Visual card comparison.
                HStack(alignment: .bottom, spacing: 30) {
                    // Player's Side with active score label.
                    VStack {
                        Text("You (\(viewModel.playerRoundScore))")
                            .font(.headline)
                            .bold()
                        HandView(cards: viewModel.playerHand)
                    }
                    
                    // Divider text.
                    Text("VS")
                        .font(.title)
                        .italic()
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 60)
                    
                    // CPU's Side with active score label.
                    VStack {
                        Text("CPU (\(viewModel.cpuRoundScore))")
                            .font(.headline)
                            .bold()
                        HandView(cards: viewModel.cpuHand)
                    }
                }
                
                // 3. Dynamic Feedback Message (Instructions or Results).
                Text(viewModel.feedbackMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    // Animation ensures text changes are smooth.
                    .animation(.default, value: viewModel.feedbackMessage)
                
                Spacer()
                
                // 4. Button Controls: Logic passed in for the Stats button.
                ControlButtonsView(viewModel: viewModel) {
                    showStats = true
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            // LAYER 3: Win/Loss Overlay (appears only when gameWinner is set).
            if let winner = viewModel.gameWinner {
                ZStack {
                    // Dim the background.
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // Success/Failure headline.
                        Text(winner == "Player" ? "🏆 YOU WIN! 🏆" : "💀 GAME OVER 💀")
                            .font(.system(size: 40, weight: .black))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(winner == "Player" ? "You have captured all 52 cards!" : "The CPU has captured your entire deck.")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Restart button.
                        Button {
                            withAnimation {
                                viewModel.setupGame()
                            }
                        } label: {
                            Text("Play Again")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(30)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        // Sheet for Rules.
        .sheet(isPresented: $showRules) {
            RulesView()
        }
        // Sheet for Lifetime History.
        .sheet(isPresented: $showStats) {
            StatsView(stats: viewModel.stats)
        }
    }
}

// MARK: - RulesView
/// A simple instructional overlay explaining the game mechanics.
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
