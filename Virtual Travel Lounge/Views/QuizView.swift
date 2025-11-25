import SwiftUI
import CoreData

struct QuizView: View {
    let destination: Destination
    @State private var current = 0
    @State private var selectedIndex: Int? = nil
    @State private var showCongrats = false
    @State private var score = 0
    @State private var answered = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.05, blue: 0.15),
                    Color(red: 0.07, green: 0.18, blue: 0.38),
                    Color(red: 0.24, green: 0.05, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Text("Quiz")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                    Text(destination.title)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal)

                // Progress
                ProgressView(value: Double(current), total: Double(max(destination.quiz.count, 1)))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .padding(.horizontal)

                if current < destination.quiz.count {
                    let q = destination.quiz[current]

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Question \(current + 1) of \(destination.quiz.count)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

                        Text(q.question)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()

                    VStack(spacing: 18) {
                        ForEach(0..<q.options.count, id: \.self) { i in
                            Button(action: {
                                guard !answered else { return }
                                answer(i, correct: q.correctIndex)
                            }) {
                                HStack {
                                    Text(q.options[i])
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .padding()
                                    Spacer()
                                }
                                .background(answerBackgroundColor(i))
                                .cornerRadius(16)
                                .scaleEffectOnFocus()
                                .shadow(color: Color.black.opacity(0.6), radius: selectedIndex == i ? 14 : 6, x: 0, y: 8)
                            }
                            .disabled(answered)
                        }
                    }
                    .padding(.horizontal)

                    HStack {
                        Spacer()
                        if answered {
                            Button(action: { goToNext() }) {
                                Text(current + 1 < destination.quiz.count ? "Next" : "Finish")
                                    .bold()
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 30)
                                    .background(
                                        LinearGradient(colors: [Color.cyan, Color.blue], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                            .padding()
                        }
                    }
                } else {
                    // Final score
                    VStack(spacing: 16) {
                        Text("All done!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("You scored \(score) out of \(destination.quiz.count)")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.9))

                        Button(action: {
                            saveResult()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save & Close")
                                .bold()
                                .padding(.vertical, 12)
                                .padding(.horizontal, 28)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .onAppear {
                        showCongrats = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { showCongrats = false }
                    }
                }

                Spacer()
            }
            .padding(.top, 24)

            if showCongrats {
                ConfettiView()
                    .ignoresSafeArea()
            }
        }
    }

    private func answer(_ index: Int, correct: Int) {
        selectedIndex = index
        answered = true
        if index == correct { score += 1 }
    }

    private func answerBackgroundColor(_ i: Int) -> Color {
        if !answered { return Color(.sRGB, red: 0.12, green: 0.12, blue: 0.14, opacity: 0.6) }
        guard let sel = selectedIndex else { return Color.gray }
        if sel == i {
            return sel == destination.quiz[current].correctIndex ? Color.green : Color.red
        }
        // show correct answer highlight
        if i == destination.quiz[current].correctIndex { return Color.green.opacity(0.6) }
        return Color.secondary.opacity(0.12)
    }

    private func goToNext() {
        answered = false
        selectedIndex = nil
        if current + 1 < destination.quiz.count {
            current += 1
        } else {
            current = destination.quiz.count
        }
    }

    private func saveResult() {
        // save to Core Data
        let entity = NSEntityDescription.entity(forEntityName: "QuizResult", in: viewContext)!
        let obj = NSManagedObject(entity: entity, insertInto: viewContext)
        obj.setValue(UUID(), forKey: "id")

        // attach to first profile if exists
        var profileId = UUID()
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        fetch.fetchLimit = 1
        do {
            let profiles = try viewContext.fetch(fetch)
            if let first = profiles.first, let pid = first.value(forKey: "id") as? UUID {
                profileId = pid
            }
        } catch { }

        obj.setValue(profileId, forKey: "profileID")
        obj.setValue(destination.id, forKey: "destinationID")
        obj.setValue(Int32(score), forKey: "score")
        obj.setValue(Int32(destination.quiz.count), forKey: "total")
        obj.setValue(Date(), forKey: "date")

        do { try viewContext.save() } catch { print("Failed to save quiz result: \(error)") }
    }
}
