import Foundation
import Observation
import SwiftUI

// MARK: - GameViewModel
/// Manages the state and logic for the Higher or Lower War game.
/// Adheres to the MVVM pattern and uses the Observation framework.
@Observable
class GameViewModel {
    
    // MARK: - Stored properties
    
    // Arrays representing the player's and CPU's current face-down decks.
    var playerDeck: [Card] = []
    var cpuDeck: [Card] = []
    
    // The "War Pile" stores cards from rounds that ended in a tie.
    var warPile: [Card] = []
    
    // Hands representing all cards drawn by each player in the current round.
    var playerHand: [Card] = []
    var cpuHand: [Card] = []
    
    // Computed property to always get the most recently drawn card for the player.
    var playerCurrentCard: Card? {
        return playerHand.last
    }
    
    // Computed property to always get the most recently drawn card for the CPU.
    var cpuCurrentCard: Card? {
        return cpuHand.last
    }
    
    // Current round totals calculated by summing the ranks of all cards in the hand.
    var playerRoundScore: Int = 0
    var cpuRoundScore: Int = 0
    
    // Keeps track of every card used in the current round for distribution later.
    var cardsUsedInRound: [Card] = []
    
    // Turn Management properties to drive the UI state.
    var isPlayerTurn: Bool = false      // True when the player is guessing.
    var isCPUThinking: Bool = false    // True while the async CPU task is running.
    var isRoundOver: Bool = false      // True after a winner is determined for the round.
    var feedbackMessage: String = "Press 'Deal' to start!" // UI text for instructions.
    
    // The final winner of the entire 52-card game (nil if game is in progress).
    var gameWinner: String? = nil
    
    // Persistence: The current lifetime statistics for the user.
    var stats: GameStats = StatsManager.shared.load()
    
    // MARK: - Initializer
    
    init() {
        // Automatically start the setup when the ViewModel is created.
        setupGame()
    }
    
    // MARK: - Functions
    
    /// Prepares a new 52-card game by resetting all states and splitting the deck.
    func setupGame() {
        // Create a standard deck using the static factory method in Card.
        var fullDeck: [Card] = Card.createFullDeck()
        
        // Shuffle the deck using Swift's built-in algorithm.
        fullDeck.shuffle() 
        
        // Reset all game state properties for a fresh start.
        playerDeck = []
        cpuDeck = []
        warPile = []
        gameWinner = nil
        playerHand = []
        cpuHand = []
        playerRoundScore = 0
        cpuRoundScore = 0
        
        // Split the deck equally: Every other card goes to the player/CPU.
        for index in 0..<fullDeck.count {
            let card = fullDeck[index]
            if index % 2 == 0 {
                playerDeck.append(card)
            } else {
                cpuDeck.append(card)
            }
        }
        
        feedbackMessage = "Decks split. Good luck!"
    }
    
    /// Starts a new round by drawing the initial baseline cards for both players.
    func startRound() {
        // Ensure both players still have cards; otherwise, the game is over.
        guard playerDeck.count > 0, cpuDeck.count > 0 else {
            feedbackMessage = "Game Over! One player is out of cards."
            return
        }
        
        // withAnimation ensures the UI updates (like cards appearing) are smooth.
        withAnimation {
            isRoundOver = false
            cardsUsedInRound = []
            playerHand = []
            cpuHand = []
            
            // Remove the top card from each deck.
            let pCard = playerDeck.removeFirst()
            let cCard = cpuDeck.removeFirst()
            
            // Add them to the visible hand.
            playerHand.append(pCard)
            cpuHand.append(cCard)
            
            // The initial score is just the rank of the first card.
            playerRoundScore = pCard.rank.rawValue
            cpuRoundScore = cCard.rank.rawValue
            
            // Track that these cards were used so they can be won.
            cardsUsedInRound.append(pCard)
            cardsUsedInRound.append(cCard)
            
            // Give control to the player.
            isPlayerTurn = true
            feedbackMessage = "Your turn! Guess Higher or Lower."
        }
    }
    
    /// Logic for processing a player's Higher or Lower guess.
    func playerGuess(isHigher: Bool) {
        // Safety check to ensure it's actually the player's turn.
        guard isPlayerTurn else { return }
        
        // If the player deck is empty, they can't draw another card; turn ends.
        if playerDeck.isEmpty {
            endPlayerTurn(message: "Out of cards! Turn ends.")
            return
        }
        
        // Draw the next card.
        let nextCard = playerDeck.removeFirst()
        cardsUsedInRound.append(nextCard)
        
        // Compare the new card's rank to the previous baseline card.
        let currentRank = playerCurrentCard?.rank.rawValue ?? 0
        let nextRank = nextCard.rank.rawValue
        
        withAnimation {
            // Add the new card to the visible hand stack.
            playerHand.append(nextCard)
            
            // Track stats: increment total guesses.
            stats.totalGuesses += 1
            
            // Determine if the guess "Higher" or "Lower" was correct.
            let correctHigher = isHigher && nextRank > currentRank
            let correctLower = !isHigher && nextRank < currentRank
            
            if correctHigher || correctLower {
                // SUCCESS: Add points and increment correct guesses.
                playerRoundScore += nextRank
                stats.correctGuesses += 1
                feedbackMessage = "Correct! Score: \(playerRoundScore). Continue?"
            } else {
                // FAILURE: Turn ends immediately.
                endPlayerTurn(message: "Wrong! Your turn ends. Score: \(playerRoundScore)")
            }
            
            // Persist the updated stats to the JSON file.
            StatsManager.shared.save(stats: stats)
        }
    }
    
    /// Internal helper to transition from the Player's turn to the CPU's turn.
    private func endPlayerTurn(message: String) {
        isPlayerTurn = false
        feedbackMessage = message
        
        // We use Task {} to run the CPU's asynchronous turn without blocking the main UI thread.
        Task {
            await runCPUTurn()
        }
    }
    
    /// Asynchronous logic for the CPU's turn, allowing for delays between guesses.
    func runCPUTurn() async {
        isCPUThinking = true
        var turnActive = true
        
        while turnActive {
            // CPU stops if it runs out of cards.
            if cpuDeck.isEmpty {
                turnActive = false
                break
            }
            
            // Introduce a 1-second delay so the player can see each card being flipped.
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            let currentRank = cpuCurrentCard?.rank.rawValue ?? 0
            
            // THE "DUMB FACTOR": Instead of perfect math, the CPU picks a random midline (6-10).
            let midline = Int.random(in: 6...10)
            let guessHigher = currentRank <= midline
            
            // Draw the CPU's next card.
            let nextCard = cpuDeck.removeFirst()
            cardsUsedInRound.append(nextCard)
            
            withAnimation {
                cpuHand.append(nextCard)
            }
            
            let nextRank = nextCard.rank.rawValue
            
            // Determine if the CPU's automated guess was correct.
            let correctHigher = guessHigher && nextRank > currentRank
            let correctLower = !guessHigher && nextRank < currentRank
            
            if correctHigher || correctLower {
                cpuRoundScore += nextRank
                feedbackMessage = "CPU guessed correctly!"
            } else {
                // CPU fails: turn ends.
                feedbackMessage = "CPU guessed wrong!"
                turnActive = false
            }
        }
        
        // Brief pause before calculating the final winner of the round.
        try? await Task.sleep(nanoseconds: 500_000_000)
        isCPUThinking = false
        resolveRound()
    }
    
    /// Final step of a round: compares scores and awards cards to the winner.
    func resolveRound() {
        withAnimation {
            isRoundOver = true
            
            if playerRoundScore > cpuRoundScore {
                // PLAYER WINS: Award cards and update feedback.
                awardCards(to: .playerWin)
                feedbackMessage = "You win the round! (\(playerRoundScore) vs \(cpuRoundScore))"
            } else if cpuRoundScore > playerRoundScore {
                // CPU WINS: Award cards and update feedback.
                awardCards(to: .cpuWin)
                feedbackMessage = "CPU wins the round! (\(cpuRoundScore) vs \(playerRoundScore))"
            } else {
                // TIE: Cards move to the war pile for the next round's winner.
                for card in cardsUsedInRound {
                    warPile.append(card)
                }
                feedbackMessage = "It's a Tie! War Pile: \(warPile.count) cards."
            }
            
            // Check if this round resulted in someone winning the entire game.
            checkGameEnd()
        }
    }
    
    /// Checks if a player has successfully captured all cards in the game.
    private func checkGameEnd() {
        // If a player has no cards left and the war pile is empty, they have lost.
        if playerDeck.isEmpty && warPile.isEmpty {
            gameWinner = "CPU"
            stats.gamesLost += 1
            feedbackMessage = "Game Over! CPU wins the war."
            StatsManager.shared.save(stats: stats)
        } else if cpuDeck.isEmpty && warPile.isEmpty {
            gameWinner = "Player"
            stats.gamesWon += 1
            feedbackMessage = "Congratulations! You win the war."
            StatsManager.shared.save(stats: stats)
        }
    }
    
    /// Helper function to transfer cards from the middle of the table to a player's deck.
    private func awardCards(to winner: RoundResult) {
        var winnings: [Card] = []
        
        // Collect all cards used in this round and any cards previously in the war pile.
        for card in cardsUsedInRound { winnings.append(card) }
        for card in warPile { winnings.append(card) }
        
        // Append these cards to the bottom of the winner's deck.
        if winner == .playerWin {
            for card in winnings { playerDeck.append(card) }
        } else if winner == .cpuWin {
            for card in winnings { cpuDeck.append(card) }
        }
        
        // Reset the piles for the next round.
        warPile = []
        cardsUsedInRound = []
    }
}
