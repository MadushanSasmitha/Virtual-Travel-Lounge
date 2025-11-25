import SwiftUI
import AVFoundation
import UIKit

struct DestinationDetailView: View {
    let destination: Destination
    @State private var currentPreviewIndex = 0
    @State private var isBookmarked = false
    @State private var showPlayer = false
    @State private var showQuiz = false
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            // Full-bleed background image styled like a wide channel banner
            let resolved = destination.resolvedImageNames()
            if let bgName = resolved.first, UIImage(named: bgName) != nil {
                Image(bgName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.15),
                                Color(red: 0.02, green: 0.08, blue: 0.25).opacity(0.8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ) // dim for readability
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.09, blue: 0.2),
                        Color(red: 0.24, green: 0.06, blue: 0.35)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }

            // Foreground content in a translucent card to emulate banner+content layout
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 12) {
                            Text(destination.title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)

                            Text(destination.summary)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 16) {
                                Button(action: { showPlayer = true }) {
                                    Label("Play Tour", systemImage: "play.fill")
                                        .font(.headline)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 26)
                                        .background(
                                            LinearGradient(colors: [Color.cyan, Color.blue], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: { showQuiz = true }) {
                                    Label("Start Quiz", systemImage: "questionmark.circle")
                                        .font(.headline)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 26)
                                        .background(
                                            LinearGradient(colors: [Color.orange, Color.pink], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: { toggleBookmark() }) {
                                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                        .font(.title3)
                                        .padding(14)
                                        .background(Color.black.opacity(0.45))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(24)
                        // Use a tvOS-compatible blur style
                        .background(BlurView(style: .dark))
                        .cornerRadius(12)
                        .padding()
                        Spacer()
                    }

                    VStack(alignment: .leading) {
                        Text("Facts")
                            .font(.headline)
                            .foregroundColor(.white)
                        ForEach(destination.facts, id: \.self) { fact in
                            Text("• \(fact)")
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
                .padding(.top, 60)
            }
        }
        .sheet(isPresented: $showPlayer) {
            TourPlayerView(destination: destination)
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(destination: destination)
                .environment(\.managedObjectContext, viewContext)
        }
        .onAppear(perform: loadBookmark)
        .navigationTitle(destination.title)
    }

    private func startQuiz() {
        // navigation to quiz view - present modally or push
    }

    private func toggleBookmark() {
        isBookmarked.toggle()
        // TODO: persist via Profile/Bookmark Core Data entities
    }

    private func loadBookmark() {
        isBookmarked = false
    }
}

struct DestinationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationDetailView(destination: Destination(id: "paris", title: "Paris", region: "France", summary: "The city of lights and romance.", facts: ["Eiffel Tower","Louvre","Seine River"], imageNames: [], narrationFile: "", captions: nil, quiz: []))
    }
}
