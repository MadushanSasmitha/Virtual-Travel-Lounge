import SwiftUI

struct SettingsView: View {
    @AppStorage("captionsEnabled") var captionsEnabled: Bool = true
    @AppStorage("autoplayInterval") var autoplayInterval: Int = 3
    @AppStorage("uiScale") var uiScale: Double = 1.0

    var body: some View {
        Form {
            Toggle("Captions", isOn: $captionsEnabled)

            Picker("Autoplay (s)", selection: $autoplayInterval) {
                Text("3s").tag(3)
                Text("5s").tag(5)
                Text("8s").tag(8)
            }

            HStack(spacing: 20) {
                Text("UI Scale")
                HStack(spacing: 12) {
                    Button(action: { uiScale = max(0.8, (uiScale - 0.1).rounded(toPlaces: 1)) }) {
                        Image(systemName: "minus.circle")
                            .font(.title2)
                    }

                    Text(String(format: "%.1fx", uiScale))
                        .frame(minWidth: 44)

                    Button(action: { uiScale = min(1.4, (uiScale + 0.1).rounded(toPlaces: 1)) }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

fileprivate extension Double {
    /// Round to the given number of decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
