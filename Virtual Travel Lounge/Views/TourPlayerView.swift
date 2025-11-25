import SwiftUI
import AVKit
import AVFoundation
import UIKit

struct TourPlayerView: View {
    let destination: Destination

    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showControls = true

    @Environment(\.presentationMode) var presentationMode

    private var videoFileName: String? {
        switch destination.id.lowercased() {
        case "paris":
            return "Paris.mp4"
        case "kyoto":
            return "Kyoto.mp4"
        case "newyork", "new york":
            return "NewYork.mp4"
        case "santorini":
            return "Santorini.mp4"
        default:
            return nil
        }
    }

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                Text("Video not found")
                    .foregroundColor(.white)
            }

            if showControls {
                VStack {
                    Spacer()
                    HStack(spacing: 40) {
                        Button(action: togglePlayPause) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                        }

                        Button(action: close) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 24)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(16)
                    .padding(.bottom, 40)
                }
                .foregroundColor(.white)
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear(perform: setupPlayer)
        .onTapGesture {
            withAnimation { showControls.toggle() }
        }
    }

    private func setupPlayer() {
        guard let name = videoFileName else { return }
        let parts = name.split(separator: ".", maxSplits: 1).map(String.init)
        let resource = parts.first ?? name
        let ext = parts.count > 1 ? parts[1] : nil

        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("Video file \(name) not found in bundle")
            return
        }

        let newPlayer = AVPlayer(url: url)
        player = newPlayer
        newPlayer.play()
        isPlaying = true
    }

    private func togglePlayPause() {
        guard let player = player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    private func close() {
        player?.pause()
        player = nil
        presentationMode.wrappedValue.dismiss()
    }
}
