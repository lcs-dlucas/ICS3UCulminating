import SwiftUI

// MARK: - CardView
/// A visual representation of a single playing card using SwiftUI shapes and symbols.
struct CardView: View {
    
    // MARK: - Stored properties
    
    // The card data to display. If nil, shows a placeholder/back.
    let card: Card?
    
    // MARK: - Computed properties
    
    /// Logic to determine the primary color of the card based on the suit.
    private var suitColor: Color {
        if let card = card {
            // Hearts and Diamonds are red; Spades and Clubs are black.
            if card.suit == .hearts || card.suit == .diamonds {
                return .red
            } else {
                return .black
            }
        }
        return .gray // Gray for the placeholder state.
    }
    
    /// Logic to select the correct SF Symbol icon for the card's suit.
    private var suitIcon: String {
        guard let card = card else { return "questionmark.square.dashed" }
        switch card.suit {
        case .hearts: return "suit.heart.fill"
        case .diamonds: return "suit.diamond.fill"
        case .clubs: return "suit.club.fill"
        case .spades: return "suit.spade.fill"
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // LAYER 1: The white card background with a soft shadow.
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            
            // LAYER 2: A subtle gray border to define the card edges.
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
            
            // LAYER 3: The Rank and Suit information.
            if let card = card {
                VStack(spacing: 8) {
                    // Top-Left Rank label.
                    HStack {
                        Text(card.rank.displayName)
                            .font(.headline)
                            .foregroundStyle(suitColor)
                        Spacer()
                    }
                    .padding([.top, .leading], 10)
                    
                    Spacer()
                    
                    // Central large suit icon.
                    Image(systemName: suitIcon)
                        .font(.system(size: 40))
                        .foregroundStyle(suitColor)
                    
                    Spacer()
                    
                    // Bottom-Right Rank label (rotated 180 degrees for a classic look).
                    HStack {
                        Spacer()
                        Text(card.rank.displayName)
                            .font(.headline)
                            .foregroundStyle(suitColor)
                            .rotationEffect(.degrees(180))
                    }
                    .padding([.bottom, .trailing], 10)
                }
            } else {
                // If no card is provided, show a "mystery" placeholder.
                Image(systemName: "questionmark")
                    .font(.largeTitle)
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        // Fix the card size so all cards in a stack have uniform dimensions.
        .frame(width: 100, height: 140)
    }
}
