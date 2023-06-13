import Combine

protocol CardProvider {
    var cards: [CardDataStructure] { get }
}

class DataService: ObservableObject, CardProvider {
    @Published var cards = [CardDataStructure]()
    
    init() {
        cards = [
            .detailed(id: 1,imageName: "star", title: "Card 1", type: "detail"),
            .basic(id: 2, imageName: "star", title: "Card 2"),
            .detailed(id: 3,imageName: "star", title: "Card 3", type: "detail"),
            .basic(id: 4, imageName: "star", title: "Card 4"),
            .detailed(id: 5,imageName: "star", title: "Card 5", type: "detail"),
            .basic(id: 6, imageName: "star", title: "Card 6"),
            .detailed(id: 7,imageName: "star", title: "Card 7", type: "detail"),
            .basic(id: 8, imageName: "star", title: "Card 8"),
            .detailed(id: 9,imageName: "star", title: "Card 9", type: "detail"),
            .basic(id: 10, imageName: "star", title: "Card 10"),
            .detailed(id: 11,imageName: "star", title: "Card 11", type: "detail"),
        ]
    }
}
