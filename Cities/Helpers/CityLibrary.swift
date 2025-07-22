import SwiftUI

enum CityLibrary: CaseIterable, Hashable {
    case moscow, petersburg, novosibirsk, kazan, munich, salzburg, linz, athens, iraklion, khabarovsk

    var name: String {
        switch self {
        case .moscow: return "Москва"
        case .petersburg: return "Санкт-Петербург"
        case .novosibirsk: return "Новосибирск"
        case .kazan: return "Казань"
        case .munich: return "Мюнхен"
        case .salzburg: return "Зальцбург"
        case .linz: return "Линц"
        case .athens: return "Афины"
        case .iraklion: return "Ираклион"
        case .khabarovsk: return "Хабаровск"
        }
    }

    var year: String {
        switch self {
        case .moscow: return "1147 год"
        case .petersburg: return "1703 год"
        case .novosibirsk: return "1893 год"
        case .kazan: return "1005 год"
        case .munich: return "1158 год"
        case .salzburg: return "696 год"
        case .linz: return "799 год"
        case .athens: return "V век до н.э."
        case .iraklion: return "824 год"
        case .khabarovsk: return "1858 год"
        }
    }

    func toCity() -> City {
        City(name: name, year: year)
    }
}
