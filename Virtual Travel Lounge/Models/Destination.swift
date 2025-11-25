import Foundation
import SwiftUI

// Represents a bundled destination used by the app. Media files are referenced by filename
// and expected to be included in the app bundle (Assets or Copy Bundle Resources).
struct Destination: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let region: String
    let summary: String
    let facts: [String]
    let imageNames: [String]
    let narrationFile: String
    let captions: [Caption]?
    let quiz: [QuizQuestion]

    enum CodingKeys: String, CodingKey {
        case id, title, region, summary, facts, imageNames, captions, quiz
        case narrationFile = "audioName"
    }

    struct Caption: Codable, Hashable {
        let start: TimeInterval
        let end: TimeInterval
        let text: String
    }
}
