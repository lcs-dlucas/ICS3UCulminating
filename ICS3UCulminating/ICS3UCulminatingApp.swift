import SwiftUI

// MARK: - App Entry Point
/// The main structure that launches the "Higher or Lower War" application.
@main
struct ICS3UCulminatingApp: App {
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            // Launches the primary GameView container.
            GameView()
        }
    }
}
