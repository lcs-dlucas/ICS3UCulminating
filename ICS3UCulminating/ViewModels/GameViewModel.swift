import Foundation
import Observation

// MARK: - GameViewModel
/// Manages the state and logic for the Higher or Lower War game.
/// Adheres to the MVVM pattern and uses the Observation framework.
@Observable
class GameViewModel {
    
    // MARK: - Stored properties
    
    // Decks
    var playerDeck: [Card] = []
    var cpuDeck: [Card] = []
    var warPile: [Card] = []
    
    // Round State
    var playerCurrentCard: Card?
    var cpuCurrentCard: Card?
    var playerRoundScore: Int = 0
    var cpuRoundScore: Int = 0
    var cardsUsedInRound: [Card] = []
    
    // Turn Management
    var isPlayerTurn: Bool = false
    var isRoundOver: Bool = false
    var feedbackMessage: String = "Press 'Deal' to start!"
    
    // MARK: - Initializer
    
    init() {
        setupGame()
    }
    
    // MARK: - Functions
    
    /// Prepares the game by creating and splitting a shuffled deck.
    func setupGame() {
        var fullDeck: [Card] = Card.createFullDeck()
        fullDeck.shuffle() // Standard Swift shuffle is acceptable as it's not a higher-order transformation
        
        // Reset properties
        playerDeck = []
        cpuDeck = []
        warPile = []
        
        // Split the deck equally (26 cards each) using a loop for clarity
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
    
    /// Starts a new round by revealing the initial baseline cards.
    func startRound() {
        // Guard against empty decks
        guard playerDeck.count > 0, cpuDeck.count > 0 else {
            feedbackMessage = "Game Over! One player is out of cards."
            return
        }
        
        // Reset round state
        isRoundOver = false
        cardsUsedInRound = []
        
        // 1. Reveal top cards as initial baseline
        let pCard = playerDeck.removeFirst()
        let cCard = cpuDeck.removeFirst()
        
        playerCurrentCard = pCard
        cpuCurrentCard = cCard
        
        // 2. Set initial scores to the card's rank value
        playerRoundScore = pCard.rank.rawValue
        cpuRoundScore = cCard.rank.rawValue
        
        // 3. Add these to the list of cards used this round
        cardsUsedInRound.append(pCard)
        cardsUsedInRound.append(cCard)
        
        isPlayerTurn = true
        feedbackMessage = "Your turn! Guess Higher or Lower."
    }
    
    /// Processes the player's guess.
    func playerGuess(isHigher: Bool) {
        guard isPlayerTurn else { return }
        
        // Ensure player has a card to guess on
        if playerDeck.isEmpty {
            endPlayerTurn(message: "Out of cards! Turn ends.")
            return
        }
        
        let nextCard = playerDeck.removeFirst()
        cardsUsedInRound.append(nextCard)
        
        let currentRank = playerCurrentCard?.rank.rawValue ?? 0
        let nextRank = nextCard.rank.rawValue
        
        // Determine if guess is correct
        let correctHigher = isHigher && nextRank > currentRank
        let correctLower = !isHigher && nextRank < currentRank
        
        if correctHigher || correctLower {
            // Correct guess: update score and baseline
            playerRoundScore += nextRank
            playerCurrentCard = nextCard
            feedbackMessage = "Correct! Score: \(playerRoundScore). Continue?"
        } else {
            // Incorrect guess: update baseline and end turn
            playerCurrentCard = nextCard
            endPlayerTurn(message: "Wrong! Your turn ends. Score: \(playerRoundScore)")
        }
    }
    
    /// Ends the player's turn and triggers the CPU logic.
    private func endPlayerTurn(message: String) {
        isPlayerTurn = false
        feedbackMessage = message
        
        // Brief delay simulation would happen in View, here we just run logic
        runCPUTurn()
    }
    
    /// Simple rule-based strategy for the CPU.
    func runCPUTurn() {
        var turnActive = true
        
        while turnActive {
            // CPU stops if it runs out of cards
            if cpuDeck.isEmpty {
                turnActive = false
                break
            }
            
            let currentRank = cpuCurrentCard?.rank.rawValue ?? 0
            
            // Rule: If card is 8 or lower, guess Higher. Otherwise, guess Lower.
            let guessHigher = currentRank <= 8
            
            let nextCard = cpuDeck.removeFirst()
            cardsUsedInRound.append(nextCard)
            let nextRank = nextCard.rank.rawValue
            
            let correctHigher = guessHigher && nextRank > currentRank
            let correctLower = !guessHigher && nextRank < currentRank
            
            if correctHigher || correctLower {
                cpuRoundScore += nextRank
                cpuCurrentCard = nextCard
            } else {
                cpuCurrentCard = nextCard
                turnActive = false
            }
        }
        
        resolveRound()
    }
    
    /// Decides the winner of the round and distributes cards.
    func resolveRound() {
        isRoundOver = true
        
        if playerRoundScore > cpuRoundScore {
            // Player wins: takes all cards used + war pile
            awardCards(to: .playerWin)
            feedbackMessage = "You win the round! (\(playerRoundScore) vs \(cpuRoundScore))"
        } else if cpuRoundScore > playerRoundScore {
            // CPU wins: takes all cards used + war pile
            awardCards(to: .cpuWin)
            feedbackMessage = "CPU wins the round! (\(cpuRoundScore) vs \(playerRoundScore))"
        } else {
            // Tie: Add cards used to the war pile
            for card in cardsUsedInRound {
                warPile.append(card)
            }
            feedbackMessage = "It's a Tie! War Pile: \(warPile.count) cards."
        }
    }
    
    /// Helper to distribute cards at the end of a round.
    private func awardCards(to winner: RoundResult) {
        var winnings: [Card] = []
        
        // Combine current cards and war pile
        for card in cardsUsedInRound { winnings.append(card) }
        for card in warPile { winnings.append(card) }
        
        // Add to winner's deck
        if winner == .playerWin {
            for card in winnings { playerDeck.append(card) }
        } else if winner == .cpuWin {
            for card in winnings { cpuDeck.append(card) }
        }
        
        // Clear temporary piles
        warPile = []
        cardsUsedInRound = []
    }
}
