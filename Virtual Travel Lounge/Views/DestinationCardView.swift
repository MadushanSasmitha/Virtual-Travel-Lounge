import SwiftUI
import UIKit

struct DestinationCardView: View {
    let destination: Destination
    @Environment(\.isFocused) private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Attempt to load first image; fallback to stylized placeholder
            let resolved = destination.resolvedImageNames()
            let matched = resolved.first(where: { UIImage(named: $0) != nil })
            if let name = matched {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        Text(destination.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                // Show a subtle region tag
                Text(destination.region.uppercased())
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(6)

                // Title appears and highlights on focus (hover)
                Text(destination.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.white)
                    .opacity(isFocused ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.15), value: isFocused)
            }
            .padding(16)
            // No debug overlays in production view.
        }
        .cornerRadius(12)
        .shadow(radius: 8)
        .focusable(true)
        .scaleEffectOnFocus()
    }
}

struct DestinationCardView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationCardView(destination: Destination(id: "paris", title: "Paris", region: "France", summary: "City of lights.", facts: ["Eiffel Tower"], imageNames: [], narrationFile: "", captions: nil, quiz: []))
            .frame(width: 520, height: 320)
    }
}
