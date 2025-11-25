import Foundation
import Combine
import CoreData

final class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        DataService.shared.$destinations
            .receive(on: DispatchQueue.main)
            .assign(to: \.destinations, on: self)
            .store(in: &cancellables)
    }
}
