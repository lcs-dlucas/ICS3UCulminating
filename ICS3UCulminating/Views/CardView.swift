import SwiftUI

// MARK: - CardView
/// A visual representation of a single playing card.
struct CardView: View {
    
    // MARK: - Stored properties
    
    let card: Card?
    
    // MARK: - Computed properties
    
    /// Determines the color of the card based on the suit.
    private var suitColor: Color {
        if let card = card {
            if card.suit == .hearts || card.suit == .diamonds {
                return .red
            } else {
                return .black
            }
        }
        return .gray
    }
    
    /// Returns the system image name for the suit icon.
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
            // Card Background
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            
            // Card Border
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
            
            if let card = card {
                VStack(spacing: 8) {
                    // Top Rank
                    HStack {
                        Text(card.rank.displayName)
                            .font(.headline)
                            .foregroundStyle(suitColor)
                        Spacer()
                    }
                    .padding([.top, .leading], 10)
                    
                    Spacer()
                    
                    // Central Suit Icon
                    Image(systemName: suitIcon)
                        .font(.system(size: 40))
                        .foregroundStyle(suitColor)
                    
                    Spacer()
                    
                    // Bottom Rank (inverted)
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
                // Placeholder for when no card is revealed
                Image(systemName: "questionmark")
                    .font(.largeTitle)
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .frame(width: 100, height: 140)
    }
}

#Preview {
    HStack {
        CardView(card: Card(rank: .ace, suit: .spades))
        CardView(card: Card(rank: .jack, suit: .hearts))
        CardView(card: nil)
    }
    .padding()
    .background(.gray.opacity(0.1))
}
