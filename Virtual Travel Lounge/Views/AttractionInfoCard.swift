import SwiftUI

struct AttractionInfoCard: View {
    let info: AttractionInfo
    let onTap: () -> Void
    @State private var isHovered = false
    @State private var animateGradient = false
    @FocusState private var isFocused: Bool
    
    private var gradientColors: [Color] {
        switch info.category {
        case "Ancient Wonder", "Archaeological Site", "Temple Complex":
            return [Color.orange.opacity(0.8), Color.red.opacity(0.6), Color.pink.opacity(0.4)]
        case "Natural Wonder", "Natural Phenomenon", "Marine Ecosystem":
            return [Color.green.opacity(0.8), Color.teal.opacity(0.6), Color.blue.opacity(0.4)]
        case "Mountain Peak", "Geological Formation", "Geological Wonder":
            return [Color.brown.opacity(0.8), Color.orange.opacity(0.6), Color.yellow.opacity(0.4)]
        case "Desert", "Salt Flat":
            return [Color.yellow.opacity(0.8), Color.orange.opacity(0.6), Color.red.opacity(0.4)]
        case "Rainforest", "Wildlife Sanctuary", "Endemic Ecosystem":
            return [Color.green.opacity(0.8), Color.mint.opacity(0.6), Color.cyan.opacity(0.4)]
        default:
            return [Color.purple.opacity(0.8), Color.blue.opacity(0.6), Color.cyan.opacity(0.4)]
        }
    }
    
    var body: some View {
        Button(action: {
            print("Button action triggered for: \(info.title)")
            onTap()
        }) {
            let headerSection = createHeaderSection()
            let factSection = createFactSection()
            let footerSection = createFooterSection()
            
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                factSection
                footerSection
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(24)
        .frame(width: 360, height: 220)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.2)
                            ] + gradientColors.map { $0.opacity(0.1) },
                            startPoint: animateGradient ? .topLeading : .bottomTrailing,
                            endPoint: animateGradient ? .bottomTrailing : .topLeading
                        )
                    )
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.4) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .opacity(isHovered ? 1.0 : 0.6)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
            }
        )
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .shadow(
            color: gradientColors.first?.opacity(0.3) ?? Color.purple.opacity(0.3),
            radius: isHovered ? 20 : 10,
            x: 0,
            y: isHovered ? 10 : 5
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isHovered)
        .focused($isFocused)
        .onChange(of: isFocused) { focused in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered = focused
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
    }
    
    private func createHeaderSection() -> some View {
        HStack {
            createIconCircle()
            createTitleSection()
            Spacer()
            createDecorativeCircles()
        }
    }
    
    private func createIconCircle() -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                )
                .frame(width: 50, height: 50)
                .scaleEffect(isHovered ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
            
            Image(systemName: info.icon)
                .font(.title2)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
        }
    }
    
    private func createTitleSection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(info.title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .cyan.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.cyan)
                
                Text(info.location)
                    .font(.subheadline)
                    .foregroundColor(.cyan.opacity(0.9))
                    .lineLimit(1)
            }
        }
    }
    
    private func createDecorativeCircles() -> some View {
        VStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 8, height: 8)
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 6, height: 6)
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 4, height: 4)
        }
    }
    
    private func createFactSection() -> some View {
        Text(info.fact)
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.95))
            .lineLimit(4)
            .multilineTextAlignment(.leading)
            .lineSpacing(2)
    }
    
    private func createFooterSection() -> some View {
        HStack {
            createCategoryBadge()
            Spacer()
            createArrowIcon()
        }
    }
    
    private func createCategoryBadge() -> some View {
        HStack(spacing: 6) {
            Image(systemName: "sparkles")
                .font(.caption2)
                .foregroundColor(.yellow)
            
            Text(info.category)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .textCase(.uppercase)
                .tracking(0.5)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: gradientColors.map { $0.opacity(0.3) },
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: gradientColors.map { $0.opacity(0.6) },
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private func createArrowIcon() -> some View {
        Image(systemName: "arrow.up.right")
            .font(.caption)
            .foregroundColor(.white.opacity(0.6))
            .scaleEffect(isHovered ? 1.2 : 1.0)
            .animation(.spring(response: 0.2), value: isHovered)
    }
}
