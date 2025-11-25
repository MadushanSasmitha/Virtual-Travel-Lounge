import SwiftUI
import CoreData

struct ProfileModalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) private var profiles: FetchedResults<Profile>

    @State private var name = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Name", text: $name)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.sRGB, red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0))
                    )
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                Button("Create") {
                    createProfile()
                }

                List {
                    ForEach(profiles, id: \ .self) { p in
                        Text(p.name ?? "Unnamed")
                    }
                    .onDelete(perform: delete)
                }

                Spacer()
            }
            .navigationTitle("Profiles")
        }
    }

    private func createProfile() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: viewContext)!
        let obj = NSManagedObject(entity: entity, insertInto: viewContext)
        obj.setValue(UUID(), forKey: "id")
        obj.setValue(name, forKey: "name")
        obj.setValue("person.crop.circle", forKey: "avatar")
        do { try viewContext.save(); name = "" } catch { print("profile save error: \(error)") }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { profiles[$0] }.forEach(viewContext.delete)
        do { try viewContext.save() } catch { print("delete error: \(error)") }
    }
}
