import SwiftUI

struct BasicCardView: View {
    @ObservedObject var viewModel: CardViewModel
    var card: CardDataStructure
    
    var isValidCard: Bool {
        switch card {
        case let .basic(id, _, _),
            let .detailed(id, _, _, _):
            return viewModel.validIds.contains(id)
        }
    }
    
    
    
    @State private var scale: CGFloat = 1.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var backgroundColor: Color {
        switch card {
        case .basic:
            return Color(red: 18/255, green: 201/255, blue: 125/255)
        case .detailed:
            return Color(red: 50/255, green: 128/255, blue: 6/255)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            switch card {
            case let .basic(_, imageName, title),
                let .detailed(_, imageName, title, _):
                Image(systemName: imageName)
                    .imageScale(.large)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                Text("This is a Car card.")
                    .foregroundColor(.white)
            }
        }
        .padding(.leading, 12)
        .padding(.top, 20)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .topLeading)
        .frame(height: 300)
        .background(backgroundColor)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 12)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                .padding(.horizontal)
        )
        .scaleEffect(isValidCard ? scale : 1.0)
        .onAppear {
            if isValidCard {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 0.9
                }
            }
        }
        .onReceive(timer) { _ in
            if self.isValidCard {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.scale = self.scale == 1.0 ? 0.9 : 1.0
                }
            }
        }
    }
}
