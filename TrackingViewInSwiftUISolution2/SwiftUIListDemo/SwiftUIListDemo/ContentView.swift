import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: CardViewModel
    
    init(dataService: CardProvider) {
        self.viewModel = CardViewModel(dataService: dataService)
    }
    
    @State private var animationAmount = 1.0
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.dataService.cards) { card in
                    CardView(viewModel: viewModel, card: card)
                        .onFullyVisible {
                            viewModel.cardAppeared(card)
                        }.onNotFullyVisible {
                            viewModel.cardDisappeared(card)
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataService: DataService())
    }
}

enum CardType {
    case basic
    case detailed
    case header
    case footer
}


