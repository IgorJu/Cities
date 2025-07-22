import SwiftUI

/// ViewModel, управляющий списками городов и состоянием текущего выбора.
///
/// Используется для отображения, редактирования и добавления списков городов в приложении.
/// Все изменения списков и их содержимого отражаются через `@Published` свойства.

final class CityListViewModel: ObservableObject {
    //MARK: - Properties
    @Published var lists: [CityList]
    @Published var currentShortName: String = ""
    @Published var currentFullName: String = ""
    @Published var currentColor: Color = .gray
    @Published var editMode: EditMode = .inactive
    @Published var draggingCity: City?

    @Published var currentIndex: Int = 0 {
        didSet {
            guard lists.indices.contains(currentIndex) else { return }
            currentCities = lists[currentIndex].cities
            currentShortName = lists[currentIndex].shortName
            currentFullName = lists[currentIndex].fullName
            currentColor = lists[currentIndex].color
        }
    }
    
    @Published var currentCities: [City] = [] {
        didSet {
            guard lists.indices.contains(currentIndex) else { return }
            lists[currentIndex].cities = currentCities
        }
    }
    
    //MARK: - Init
    init() {
        let europeCities = [
            City(name: "Хабаровск", year: "1858 год"),
            City(name: "Ираклион", year: "824 год"),
            City(name: "Афины", year: "V век до н.э."),
            City(name: "Мюнхен", year: "1158 год"),
            City(name: "Зальцбург", year: "696 год")
        ]
        
        let europeList = CityList(
            shortName: "EU",
            fullName: "Список городов в Европе",
            color: .blue,
            cities: europeCities
        )
        
        self.lists = [europeList]
        setCurrentList(to: 0)
    }
}

//MARK: - Extensions
private extension CityListViewModel {
    func setCurrentList(to index: Int) {
        guard lists.indices.contains(index) else { return }
        currentIndex = index
        currentCities = lists[index].cities
        currentShortName = lists[index].shortName
        currentFullName = lists[index].fullName
        currentColor = lists[index].color
    }
}

extension CityListViewModel {
    func addList(short: String, full: String, color: Color, cities: [City]) {
        let newList = CityList(shortName: short, fullName: full, color: color, cities: cities)
        lists.append(newList)
        setCurrentList(to: lists.count - 1)
    }
}
