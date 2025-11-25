import SwiftUI

struct AttractionDetailOverlay: View {
    let info: AttractionInfo
    @Binding var isVisible: Bool
    
    private var gradientColors: [Color] {
        switch info.category {
        case "Ancient Wonder", "Archaeological Site", "Temple Complex":
            return [Color.orange.opacity(0.9), Color.red.opacity(0.7), Color.pink.opacity(0.5)]
        case "Natural Wonder", "Natural Phenomenon", "Marine Ecosystem":
            return [Color.green.opacity(0.9), Color.teal.opacity(0.7), Color.blue.opacity(0.5)]
        case "Mountain Peak", "Geological Formation", "Geological Wonder":
            return [Color.brown.opacity(0.9), Color.orange.opacity(0.7), Color.yellow.opacity(0.5)]
        case "Desert", "Salt Flat":
            return [Color.yellow.opacity(0.9), Color.orange.opacity(0.7), Color.red.opacity(0.5)]
        case "Rainforest", "Wildlife Sanctuary", "Endemic Ecosystem":
            return [Color.green.opacity(0.9), Color.mint.opacity(0.7), Color.cyan.opacity(0.5)]
        default:
            return [Color.purple.opacity(0.9), Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]
        }
    }
    
    var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .allowsHitTesting(true)
                    .onTapGesture {
                        print("Background tapped - closing overlay")
                        withAnimation(.easeOut(duration: 0.3)) {
                            isVisible = false
                        }
                    }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        createHeader()
                        createDescription()
                        createHighlights()
                        createFunFacts()
                        createTravelInfo()
                        
                        // Additional close button at bottom
                        HStack {
                            Spacer()
                            Button(action: {
                                print("Bottom close button tapped")
                                withAnimation(.easeOut(duration: 0.3)) {
                                    isVisible = false
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "xmark.circle")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Close")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .padding(.top, 16)
                    }
                    .padding(32)
                }
                .frame(maxWidth: 600, maxHeight: 500)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.9),
                                    Color.black.opacity(0.7)
                                ] + gradientColors.map { $0.opacity(0.2) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(
                                        colors: gradientColors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                )
                .shadow(color: gradientColors.first?.opacity(0.5) ?? Color.purple.opacity(0.5), radius: 30, x: 0, y: 15)
                .allowsHitTesting(true)
                .contentShape(Rectangle())
            }
            .allowsHitTesting(true)
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.6, dampingFraction: 0.8)),
                removal: .scale.combined(with: .opacity).animation(.easeOut(duration: 0.3))
            ))
        }
    }
    
    private func createHeader() -> some View {
        HStack {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: info.icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(info.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, gradientColors.first?.opacity(0.9) ?? .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.subheadline)
                        .foregroundColor(gradientColors.first ?? .cyan)
                    
                    Text(info.location)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text(info.detailedInfo.coordinates)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
            
            Button(action: {
                print("Close button tapped")
                withAnimation(.easeOut(duration: 0.3)) {
                    isVisible = false
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3), value: isVisible)
        }
    }
    
    private func createDescription() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(gradientColors.first ?? .cyan)
            
            Text(info.detailedInfo.description)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
    
    private func createHighlights() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Must-See Highlights")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(gradientColors.first ?? .cyan)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(info.detailedInfo.highlights, id: \.self) { highlight in
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
                        Text(highlight)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private func createFunFacts() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fun Facts")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(gradientColors.first ?? .cyan)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(info.detailedInfo.funFacts, id: \.self) { fact in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.top, 2)
                        
                        Text(fact)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func createTravelInfo() -> some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundColor(gradientColors.first ?? .cyan)
                    
                    Text("Best Time to Visit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(info.detailedInfo.bestTimeToVisit)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "tag.fill")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                    
                    Text("Category")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(info.category)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: gradientColors.map { $0.opacity(0.4) },
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
        }
    }
}
