import Foundation

struct QuizQuestion: Identifiable, Codable, Hashable {
    // Generate a stable identity locally instead of decoding it from JSON.
    // The bundled JSON only provides question, options, and correctIndex.
    let id = UUID().uuidString
    let question: String
    let options: [String]
    let correctIndex: Int

    enum CodingKeys: String, CodingKey {
        case question, options, correctIndex
    }
}
