import SwiftUI

struct City: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let year: String

    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}
