import Foundation
import Combine

class CardVisibilityTracker: ObservableObject {
    @Published var visibleCards: Set<CardDataStructure> = []
    private var cancellables = Set<AnyCancellable>()
    
    weak var cellVisibilityDelegate: CellVisibilityDelegate?
    
    func cardAppeared(_ card: CardDataStructure) {
        visibleCards.insert(card)
    }
    
    func cardDisappeared(_ card: CardDataStructure) {
        visibleCards.remove(card)
    }
    
    func extractVisibleCardIds(_ visibleCards: Set<CardDataStructure>) -> [Int] {
        let ids = visibleCards.compactMap { (card) -> Int? in
            switch card {
            case let .basic(id, _, _),
                 let .detailed(id, _, _, _):
                return id
            }
        }
        return ids.sorted()
    }
    
    
    init() {
        setupSubscription()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func setupSubscription() {
        $visibleCards
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] cards in
                if let self = self {
                    let validIds = self.extractVisibleCardIds(self.visibleCards)
                    self.cellVisibilityDelegate?.visibleCellsChanged(visibleCells: validIds)
                }
            }
            .store(in: &cancellables)
    }
}
