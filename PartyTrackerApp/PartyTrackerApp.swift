import SwiftUI

@main
struct PartyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.035, green: 0.065, blue: 0.105),
                    Color(red: 0.015, green: 0.028, blue: 0.048)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Party Tracker")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Dodaj widget „Party Tracker” do ekranu początkowego.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.68))
                    .multilineTextAlignment(.center)

                StaticPreviewCard()
                    .frame(width: 300, height: 300)
                    .padding(.top, 8)
            }
            .padding(24)
        }
    }
}
