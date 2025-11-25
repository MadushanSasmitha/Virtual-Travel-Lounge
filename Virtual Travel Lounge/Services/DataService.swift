import Foundation
import Combine

/// Loads bundled JSON that describes demo destinations.
final class DataService: ObservableObject {
    static let shared = DataService()

    @Published private(set) var destinations: [Destination] = []

    private var cancellables = Set<AnyCancellable>()

    private init() {
        loadBundleJSON()
    }

    func loadBundleJSON() {
        guard let url = Bundle.main.url(forResource: "destinations", withExtension: "json") else {
            print("destinations.json not found in bundle — falling back to built-in sample data")
            // Fallback: provide built-in demo destinations so the UI shows in the simulator
            fallbackSeed()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            struct Wrapper: Codable { let destinations: [Destination] }
            let wrapper = try decoder.decode(Wrapper.self, from: data)
            DispatchQueue.main.async {
                self.destinations = wrapper.destinations
                // Debug output to help confirm quiz counts loaded from bundle
                print("DataService: loaded \(wrapper.destinations.count) destinations from bundle")
                for d in wrapper.destinations {
                    print(" - \(d.id): quiz count = \(d.quiz.count)")
                }
            }
        } catch {
            print("Error decoding destinations.json: \(error) — falling back to built-in sample data")
            fallbackSeed()
        }
    }

    private func fallbackSeed() {
        let sample: [Destination] = [
            Destination(id: "paris", title: "Paris", region: "France", summary: "The City of Light — museums, cafés, and the Seine.", facts: ["Eiffel Tower", "Louvre Museum", "Seine River"], imageNames: ["Paris"], narrationFile: "paris_narration.mp3", captions: nil, quiz: []),
            Destination(id: "kyoto", title: "Kyoto", region: "Japan", summary: "Historic temples, tea houses, and seasonal gardens.", facts: ["Fushimi Inari Shrine", "Arashiyama Bamboo Grove", "Gion District"], imageNames: ["Kyoto"], narrationFile: "kyoto_narration.mp3", captions: nil, quiz: []),
            Destination(id: "santorini", title: "Santorini", region: "Greece", summary: "Caldera views and whitewashed villages overlooking the Aegean.", facts: ["Oia sunsets", "Volcanic beaches", "Blue-domed churches"], imageNames: ["Santorini"], narrationFile: "santorini_narration.mp3", captions: nil, quiz: []),
            Destination(id: "newyork", title: "New York City", region: "USA", summary: "Skyscrapers, theatre, and diverse neighborhoods.", facts: ["Times Square", "Central Park", "Statue of Liberty"], imageNames: ["NewYork"], narrationFile: "nyc_narration.mp3", captions: nil, quiz: [])
        ]

        DispatchQueue.main.async {
            self.destinations = sample
        }
    }
}
