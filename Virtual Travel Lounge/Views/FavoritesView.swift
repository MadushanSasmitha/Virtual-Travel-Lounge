import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Bookmark.entity(), sortDescriptors: []) private var bookmarks: FetchedResults<Bookmark>

    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarks, id: \ .self) { bm in
                    VStack(alignment: .leading) {
                        Text(bm.destinationID ?? "Unknown")
                        if let date = bm.createdAt {
                            Text(date, style: .date).font(.caption)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Favorites")
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { bookmarks[$0] }.forEach(viewContext.delete)
        do { try viewContext.save() } catch { print("delete error: \(error)") }
    }
}
