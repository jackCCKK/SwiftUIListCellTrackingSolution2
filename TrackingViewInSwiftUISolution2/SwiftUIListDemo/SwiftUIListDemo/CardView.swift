import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    var card: CardDataStructure
    
    var body: some View {
        Group {
            switch card {
            case .basic, .detailed:
                BasicCardView(viewModel: viewModel, card: card)
            }
        }
    }
}
