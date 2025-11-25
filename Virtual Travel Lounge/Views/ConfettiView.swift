import SwiftUI

/// Lightweight confetti using falling emoji shapes — sufficient for a prototype celebratory effect.
struct ConfettiView: View {
    @State private var drops: [Confetti] = (0..<24).map { _ in Confetti.random() }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(drops) { drop in
                    Text(drop.emoji)
                        .font(.largeTitle)
                        .position(x: drop.x * geo.size.width, y: drop.y * geo.size.height)
                        .opacity(drop.opacity)
                        .animation(.easeIn(duration: drop.duration).delay(drop.delay), value: drop.id)
                }
            }
            .onAppear {
                for i in drops.indices {
                    drops[i].y = 1.2
                    drops[i].opacity = 1.0
                }
            }
        }
    }
}

fileprivate struct Confetti: Identifiable {
    let id = UUID()
    var x: CGFloat = .random(in: 0.05...0.95)
    var y: CGFloat = .random(in: -0.4...0.2)
    var emoji: String = ["🎉","✨","🎊","🌟"].randomElement() ?? "🎉"
    var opacity: Double = 0.0
    var delay: Double = .random(in: 0...0.6)
    var duration: Double = .random(in: 1.0...2.2)

    static func random() -> Confetti { Confetti() }
}
