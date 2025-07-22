import SwiftUI

//MARK: - Constants

private enum Constants {
    enum TabBar {
        static let citiesIcon = "list.bullet"
        static let citiesLabel = "Города"
        static let colorIcon = "circle.fill"
        static let cornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 4
        static let contentPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 12
    }

    enum Sheet {
        static let detents: Set<PresentationDetent> = [.medium, .large]
    }
}

//MARK: - ContentView
///  Description:
///  Главный контейнер приложения. Содержит:
///  - TabBar с переключением на список городов и кнопку открытия меню
///  - Привязку к ViewModel
///  - Презентацию MenuSheetView в виде sheet

struct ContentView: View {
    @EnvironmentObject var viewModel: CityListViewModel
    @State private var selectedTab: Tab = .cities
    @State private var showMenuSheet = false

    enum Tab {
        case cities
    }

    var body: some View {
        content()
            .sheet(isPresented: $showMenuSheet) {
                MenuSheetView()
                    .environmentObject(viewModel)
                    .presentationDetents(Constants.Sheet.detents)
            }
            .environmentObject(viewModel)
    }
}

// MARK: - Private extension UI

private extension ContentView {
    @ViewBuilder
    func content() -> some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .cities:
                    CitiesListView()
                }
            }
            .edgesIgnoringSafeArea(.bottom)

            tabBar()
        }
    }

    func tabBar() -> some View {
        HStack {
            Button {
                withAnimation {
                    selectedTab = .cities
                }
            } label: {
                VStack {
                    Image(systemName: Constants.TabBar.citiesIcon)
                    
                    Text(Constants.TabBar.citiesLabel)
                }
                .foregroundColor(selectedTab == .cities ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)

            Button {
                withAnimation {
                    showMenuSheet = true
                }
            } label: {
                VStack {
                    Image(systemName: Constants.TabBar.colorIcon)
                        .foregroundColor(viewModel.currentColor)
                    
                    Text(viewModel.currentShortName)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(Constants.TabBar.contentPadding)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.TabBar.cornerRadius))
        .shadow(radius: Constants.TabBar.shadowRadius)
        .padding(.horizontal, Constants.TabBar.horizontalPadding)
        .padding(.bottom, Constants.TabBar.bottomPadding)
    }
}

