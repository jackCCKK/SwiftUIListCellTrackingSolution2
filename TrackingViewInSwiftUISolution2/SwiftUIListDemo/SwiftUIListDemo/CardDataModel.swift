import Foundation

enum CardDataStructure: Identifiable, Hashable {
    case basic(id: Int, imageName: String, title: String)
    case detailed(id: Int, imageName: String, title: String, type: String)
    
    var id: Int {
        switch self {
        case let .basic(id, _, _),
             let .detailed(id, _, _, _):
            return id
        }
    }
}

