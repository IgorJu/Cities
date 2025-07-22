import SwiftUI

//MARK: - Constants
private enum Constants {
    enum Navigation {
        static let title = "Города"
    }

    enum Layout {
        static let scrollPadding: CGFloat = 16
        static let rowPadding: CGFloat = 12
        static let cornerRadius: CGFloat = 8
    }

    enum Colors {
        static let rowBackground = Color(.systemGray6)
    }
}

//MARK: - CitiesListView
///  Description:
///  CitiesListView отображает список городов, привязанный к текущему списку пользователя.
///  В обычном режиме — вертикальный список с поддержкой drag & drop перемещений.
///  В режиме редактирования — стандартный SwiftUI List с возможностью перемещения.

struct CitiesListView: View {
    @EnvironmentObject var listVM: CityListViewModel
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            content()
                .navigationTitle(Constants.Navigation.title)
                .toolbar { EditButton() }
                .environment(\.editMode, $editMode)
        }
    }
}

// MARK: - Private extension UI
private extension CitiesListView {
    @ViewBuilder
    func content() -> some View {
        if editMode.isEditing {
            editableList()
        } else {
            draggableScrollView()
        }
    }

    @ViewBuilder
    func editableList() -> some View {
        List {
            ForEach(listVM.currentCities.indices, id: \.self) { index in
                HStack {
                    Text(listVM.currentCities[index].name)
                    
                    Spacer()
                    
                    Text(listVM.currentCities[index].year)
                }
            }
            .onMove { from, to in
                listVM.currentCities.move(fromOffsets: from, toOffset: to)
            }
        }
    }

    @ViewBuilder
    func draggableScrollView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(listVM.currentCities) { city in
                    draggableCityRow(for: city)
                }
            }
            .padding(Constants.Layout.scrollPadding)
        }
        .scrollIndicators(.visible)
    }

    @ViewBuilder
    func draggableCityRow(for city: City) -> some View {
        HStack {
            Text(city.name)
            
            Spacer()
            
            Text(city.year)
        }
        .padding(Constants.Layout.rowPadding)
        .background(Constants.Colors.rowBackground)
        .cornerRadius(Constants.Layout.cornerRadius)
        .onDrag {
            listVM.draggingCity = city
            return NSItemProvider(object: city.name as NSString)
        } preview: {
            EmptyView()
        }
        .onDrop(of: [.text], delegate: CityDropDelegate(
            draggingItem: $listVM.draggingCity, item: city,
            listVM: listVM
        ))
    }
}
