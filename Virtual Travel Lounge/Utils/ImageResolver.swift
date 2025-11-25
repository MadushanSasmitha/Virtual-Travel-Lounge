import Foundation
import UIKit

/// Helpers to resolve image names provided in JSON to actual bundle/asset names.
/// This is tolerant: it will try the original name, then the name without file extension.
func uiImageExists(named name: String) -> Bool {
    return UIImage(named: name) != nil
}

func stripFileExtension(_ name: String) -> String {
    if let dot = name.lastIndex(of: ".") {
        return String(name[..<dot])
    }
    return name
}

extension Destination {
    /// Returns an array of resolved image names that exist in the bundle or asset catalog.
    /// Falls back to the original `imageNames` if nothing else is found.
    func resolvedImageNames() -> [String] {
        var results: [String] = []
        for raw in imageNames {
            let candidates = [raw, stripFileExtension(raw)]
            if let found = candidates.first(where: { uiImageExists(named: $0) }) {
                results.append(found)
            }
        }
        // If nothing matched (e.g., images are named differently), fallback to stripped names
        if !results.isEmpty { return results }

        // Try additional candidate names based on the destination title and id
        var extraCandidates: [String] = []

        func fold(_ s: String) -> String {
            return s.folding(options: .diacriticInsensitive, locale: .current)
        }

        func variants(for base: String) -> [String] {
            var v: [String] = []
            v.append(base)
            v.append(base.replacingOccurrences(of: " ", with: ""))
            v.append(base.replacingOccurrences(of: " ", with: "_"))
            v.append(base.replacingOccurrences(of: " ", with: "-"))
            v.append(base.lowercased())
            v.append(base.capitalized)
            // remove punctuation
            let withoutPunct = base.components(separatedBy: CharacterSet.punctuationCharacters).joined()
            v.append(withoutPunct)
            v.append(withoutPunct.replacingOccurrences(of: " ", with: ""))
            v.append(fold(base).lowercased())
            // Also try joins of first N words (e.g. "New York City" -> "New", "NewYork", "NewYorkCity")
            let words = base.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
            if !words.isEmpty {
                for i in 1...min(words.count, 3) {
                    let firstN = words.prefix(i).joined()
                    v.append(firstN)
                    v.append(firstN.lowercased())
                    v.append(firstN.replacingOccurrences(of: " ", with: "_"))
                }
            }
            return Array(Set(v)) // unique
        }

        extraCandidates.append(contentsOf: variants(for: title))
        extraCandidates.append(contentsOf: variants(for: id))
        // Also try stripped forms
        extraCandidates.append(contentsOf: extraCandidates.map { stripFileExtension($0) })

        for candidate in extraCandidates {
            if uiImageExists(named: candidate) {
                // prefer first strong matches
                if !results.contains(candidate) { results.append(candidate) }
            }
        }

        // Last fallback: return stripped names (useful if assets were added without extensions)
        if results.isEmpty {
            return imageNames.map { stripFileExtension($0) }
        }
        return results
    }
}
