import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @StateObject private var attractionService = AttractionInfoService()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var refreshRotation: Double = 0
    @State private var showNewBadge = true
    @State private var selectedAttraction: AttractionInfo?
    @State private var showAttractionDetail = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Virtual Travel Lounge")
                    .font(.system(size: 54, weight: .bold, design: .default))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.cyan, Color.blue, Color.purple], startPoint: .leading, endPoint: .trailing)
                    )
                    .padding(.leading, 40)

                ScrollView(.horizontal, showsIndicators: false) {
                    // Increased spacing for clearer separation on the Apple TV screen
                    HStack(spacing: 64) {
                        ForEach(vm.destinations) { dest in
                            NavigationLink(value: dest) {
                                DestinationCardView(destination: dest)
                                    .frame(width: 520, height: 320)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(height: 380)

                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Text("Discover Amazing Places")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .cyan, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                if showNewBadge {
                                    HStack(spacing: 4) {
                                        Image(systemName: "sparkles")
                                            .font(.caption2)
                                            .foregroundColor(.yellow)
                                        
                                        Text("NEW")
                                            .font(.system(size: 10, weight: .black, design: .rounded))
                                            .foregroundColor(.white)
                                            .tracking(1)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.orange, .pink, .purple],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                    .scaleEffect(showNewBadge ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: showNewBadge)
                                }
                            }
                            
                            Text("Fresh insights from around the world • Updated daily")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                refreshRotation += 360
                            }
                            attractionService.refreshContent()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan.opacity(0.3), .blue.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.cyan, .blue],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                
                                Image(systemName: "arrow.clockwise")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(refreshRotation))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: refreshRotation)
                    }
                    .padding(.horizontal, 40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            ForEach(attractionService.currentInfo) { info in
                                AttractionInfoCard(info: info) {
                                    print("HomeView: Card callback triggered for \(info.title)")
                                    selectedAttraction = info
                                    showAttractionDetail = true
                                    print("HomeView: showAttractionDetail set to true")
                                }
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.6, dampingFraction: 0.8)),
                                    removal: .scale.combined(with: .opacity).animation(.easeInOut(duration: 0.3))
                                ))
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.04, green: 0.06, blue: 0.14),
                        Color(red: 0.08, green: 0.16, blue: 0.35),
                        Color(red: 0.24, green: 0.05, blue: 0.36)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationDestination(for: Destination.self) { dest in
                DestinationDetailView(destination: dest)
            }
            .onAppear {
                attractionService.loadRandomAttractions()
            }
        }
        .fullScreenCover(isPresented: $showAttractionDetail) {
            if let selectedAttraction = selectedAttraction {
                AttractionDetailOverlay(info: selectedAttraction, isVisible: $showAttractionDetail)
                    .background(Color.clear)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
