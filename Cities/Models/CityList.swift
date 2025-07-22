import SwiftUI

struct CityList: Identifiable {
    let id = UUID()
    let shortName: String
    let fullName: String
    let color: Color
    var cities: [City]
}
