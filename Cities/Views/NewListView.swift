import SwiftUI

// MARK: - Constants

private enum Constants {
    enum Text {
        static let newListTitle = "Новый список"
        static let listNameSection = "Название списка"
        static let shortNamePlaceholder = "Краткое название"
        static let fullNamePlaceholder = "Полное название"
        static let colorSection = "Цвет списка"
        static let colorPickerLabel = "Цвет"
        static let citiesSection = "Города"
        static let cancel = "Отмена"
        static let ok = "OK"
    }

    enum Symbols {
        static let checked = "checkmark.square"
        static let unchecked = "square"
    }

    enum Sizes {
        static let colorCircle: CGFloat = 20
        static let citySpacing: CGFloat = 10
        static let cityScrollPadding: CGFloat = 4
        static let cityScrollHeight: CGFloat = 220
    }

    enum Limits {
        static let maxCitySelection = 5
    }

    enum ListColors {
        static let availableColors: [(name: String, color: Color)] = [
            ("Красный", .red),
            ("Зелёный", .green),
            ("Синий", .blue),
            ("Оранжевый", .orange)
        ]
    }
}

// MARK: - NewListView
///  Description:
///  Представляет экран создания нового списка городов с возможностью выбора названия,
///  цвета и городов из доступной библиотеки.

struct NewListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listVM: CityListViewModel

    @State private var shortName: String = ""
    @State private var fullName: String = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedCities: Set<CityLibrary> = []

    private let colors = Constants.ListColors.availableColors

    var body: some View {
        content()
    }
}

private extension NewListView {
    @ViewBuilder
    func content() -> some View {
        NavigationView {
            Form {
                nameSection()
                
                colorSection()
                
                citiesSection()
            }
            .navigationTitle(Constants.Text.newListTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Constants.Text.cancel) {
                        withAnimation { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Constants.Text.ok) {
                        withAnimation {
                            let cities = selectedCities.map { $0.toCity() }
                            
                            listVM.addList(short: shortName, full: fullName, color: selectedColor, cities: cities)
                            dismiss()
                        }
                    }
                    .disabled(shortName.isEmpty || fullName.isEmpty || selectedCities.isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    func nameSection() -> some View {
        Section(header: Text(Constants.Text.listNameSection)) {
            TextField(Constants.Text.shortNamePlaceholder, text: $shortName)
            
            TextField(Constants.Text.fullNamePlaceholder, text: $fullName)
        }
    }

    @ViewBuilder
    func colorSection() -> some View {
        Section(header: Text(Constants.Text.colorSection)) {
            Picker(Constants.Text.colorPickerLabel, selection: $selectedColor) {
                ForEach(colors, id: \.color) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: Constants.Sizes.colorCircle, height: Constants.Sizes.colorCircle)
                        
                        Text(item.name)
                    }
                    .tag(item.color)
                }
            }
        }
    }

    @ViewBuilder
    func citiesSection() -> some View {
        Section(header: Text(Constants.Text.citiesSection)) {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: Constants.Sizes.citySpacing) {
                    ForEach(CityLibrary.allCases, id: \.self) { city in
                        Button(action: {
                            withAnimation {
                                
                                if selectedCities.contains(city) {
                                    selectedCities.remove(city)
                                } else if selectedCities.count < Constants.Limits.maxCitySelection {
                                    selectedCities.insert(city)
                                }
                                
                            }
                        }) {
                            HStack {
                                Image(systemName: selectedCities.contains(city) ? Constants.Symbols.checked : Constants.Symbols.unchecked)
                                    .foregroundColor(.primary)
                                
                                Text(city.name)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, Constants.Sizes.cityScrollPadding)
            }
            .frame(height: Constants.Sizes.cityScrollHeight)
        }
    }
}
