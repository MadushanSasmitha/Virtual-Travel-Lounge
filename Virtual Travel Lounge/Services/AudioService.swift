import Foundation
import AVFoundation
import Combine

/// Simple audio playback service that plays narration files bundled in the app.
final class AudioService: ObservableObject {
    static let shared = AudioService()

    @Published private(set) var player: AVAudioPlayer?
    @Published private(set) var isPlaying: Bool = false

    private init() {}

    func loadAndPlay(filename: String) {
        stop()
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Audio file \(filename) not found in bundle")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
        } catch {
            print("Audio playback error: \(error)")
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
    }
}
