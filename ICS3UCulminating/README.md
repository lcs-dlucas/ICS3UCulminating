# Higher or Lower War - Technical Documentation

## 🏗️ Architectural Pattern: MVVM
This application strictly follows the **Model-View-ViewModel (MVVM)** design pattern to ensure a clean separation of concerns between data logic and user interface.

### 1. The Model Layer (Data Structures)
The Model defines the raw data and business rules of the game. It does not know about the UI or the logic.
- **Card.swift:** Defines the `Card` struct.
    - **Array Usage:** Contains the static `createFullDeck()` function which uses a loop to generate an **Array** of 52 cards.
- **Suit.swift & Rank.swift:** Enums that provide type-safety for card attributes. `Rank` defines the integer **Input** values (2-14) used for scoring.
- **GameStats.swift:** Defines the `GameStats` struct for persistence. It uses the `StatsManager` class to handle **JSON Output** to the file system.
- **RoundResult.swift:** A simple enum used to communicate the **Output** of a round (Win, Loss, or Tie) between the ViewModel and the View.

### 2. The ViewModel Layer (The Brain)
The **GameViewModel.swift** is the "Source of Truth." It connects the Model data to the View.
- **Array Definitions:**
    - `playerDeck` / `cpuDeck`: **Arrays** that store the face-down cards.
    - `playerHand` / `cpuHand`: **Arrays** that track cards drawn in the current round (used by `HandView`).
    - `warPile`: An **Array** that holds cards during a tie.
    - `cardsUsedInRound`: A temporary **Array** used to track cards for distribution.
- **Data Invocation:** 
    - **Inputs:** Receives user commands from the View (e.g., `playerGuess()`, `startRound()`).
    - **Logic:** Invokes array mutations like `.removeFirst()` and `.append()` to move cards between decks.
    - **Async Logic:** Manages the CPU's asynchronous turn using `Task.sleep` to create a timed **Output** sequence.

### 3. The View Layer (User Interface)
The View displays the state of the ViewModel and sends user **Inputs** back to it.
- **GameView.swift:** The main container. It observes the ViewModel and updates the **Output** (UI) automatically when data changes.
- **HandView.swift:** 
    - **Array Input:** Receives the `playerHand` or `cpuHand` array as a parameter.
    - **Logic:** Iterates through the array using a `ForEach` loop to render the stacked **ZStack** of cards.
- **ControlButtonsView.swift:** The primary source of **User Input**. It invokes functions in the ViewModel when buttons are pressed.
- **CardView.swift:** A stateless component that takes a single `Card` as **Input** and produces a visual **Output**.

---

## 📊 Data Flow: Input, Output, and Arrays

### 📥 Inputs (User Actions)
1. **Guessing:** When a user clicks "Higher" or "Lower," a Boolean is passed into `viewModel.playerGuess(isHigher: Bool)`.
2. **Game Control:** The "Deal" and "Restart" buttons trigger setup logic that re-initializes all arrays.
3. **Navigation:** The "?" and "History" buttons trigger state changes that show sheets for Rules or Stats.

### 📤 Outputs (State & Persistence)
1. **State Updates:** Every change to the ViewModel's properties (like `playerRoundScore`) is a data **Output** that SwiftUI detects to re-render the screen.
2. **JSON Persistence:** When a game ends or a guess is made, the `StatsManager` converts the `GameStats` object into a **JSON Data Output** and writes it to the local `game_stats.json` file.
3. **Feedback:** The `feedbackMessage` string is a dynamic text **Output** that guides the player.

### 📚 Array Management (The Engine)
Arrays are the primary way data is managed in this game:
- **Defined:** In `GameViewModel.swift` as `[Card]` types.
- **Initialized:** In `setupGame()` where a 52-item array is split into two 26-item arrays.
- **Invoked:** 
    - `deck.removeFirst()`: Invoked at the start of every draw.
    - `hand.append(card)`: Invoked to update the visual stack.
    - `deck.append(contentsOf: winnings)`: Invoked at the end of a round to reward the winner.
    - `warPile.append(card)`: Invoked during a tie to "store" cards for later.

---

## 🚀 Technical Highlights
- **Observation Framework:** Uses `@Observable` to link the ViewModel and View without legacy property wrappers.
- **Async/Await:** Employs modern Swift concurrency to manage the CPU turn timer.
- **ZStack Layering:** Uses a `ForEach` loop over a sliced array (max 8 items) to create the overlapping card effect.
- **Error Handling:** Uses `guard` statements to safely handle empty decks and prevent crashes.
