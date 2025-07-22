import SwiftUI

//MARK: - Constants

private enum Constants {
    enum Sizes {
        static let itemWidth: CGFloat = 80
        static let itemHeight: CGFloat = 100
        static let plusSize: CGFloat = 50
        static let borderWidth: CGFloat = 2
        static let circleSelected: CGFloat = 70
        static let circleDefault: CGFloat = 50
        static let carouselHeight: CGFloat = 160
    }
    
    enum Layout {
        static let itemSpacing: CGFloat = 20
        static let vStackSpacing: CGFloat = 16
        static let vStackSpacingInner: CGFloat = 10
    }
    
    enum Colors {
        static let addButtonBackground = Color.gray.opacity(0.3)
        static let addButtonBorder = Color.black
        static let addButtonIcon = Color.black
    }
    
    enum Labels {
        static let addTitle = "Добавить"
        static let plusIcon = "plus"
    }
    
    enum Fonts {
        static let title: Font = .headline
        static let caption: Font = .caption
    }
    
    enum Threshold {
        static let plusSnapBack: CGFloat = 50
        static let snapSelection: CGFloat = 10
    }
    
    enum Animation {
        static let duration: Double = 0.2
        static let scale: CGFloat = 1.2
    }
}

//MARK: - MenuSheetView
///  Description:
///  Меню в виде нижнего листа с каруселью списков городов и кнопкой добавления.
///  Позволяет пользователю быстро переключаться между списками, а также создавать новые.

struct MenuSheetView: View {
    @EnvironmentObject var listVM: CityListViewModel
    
    @State private var showNewList = false
    @State private var itemPositions: [Int: CGFloat] = [:]
    
    var body: some View {
        content()
            .sheet(isPresented: $showNewList) {
                NewListView()
            }
    }
}

//MARK: - Private extension UI

private extension MenuSheetView {
    @ViewBuilder
    func content() -> some View {
        VStack(spacing: Constants.Layout.vStackSpacing) {
            carousel()
            
            Text(listVM.currentFullName)
                .font(Constants.Fonts.title)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func carousel() -> some View {
        GeometryReader { geo in
            let centerX = geo.frame(in: .global).midX

            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Constants.Layout.itemSpacing) {
                        GeometryReader { plusGeo in
                            let plusMidX = plusGeo.frame(in: .global).midX
                            plusCardView(plusMidX: plusMidX, centerX: centerX, scrollProxy: scrollProxy)
                        }
                        .frame(width: Constants.Sizes.itemWidth, height: Constants.Sizes.itemHeight)

                        ForEach(listVM.lists.indices, id: \.self) { idx in
                            GeometryReader { itemGeo in
                                let itemMidX = itemGeo.frame(in: .global).midX
                                carouselItemView(idx: idx, itemMidX: itemMidX, centerX: centerX)
                                    .id(idx)
                            }
                            .frame(width: Constants.Sizes.itemWidth, height: Constants.Sizes.itemHeight)
                        }
                    }
                    .padding(.horizontal, (geo.size.width - Constants.Sizes.itemWidth) / 2)
                }
                .onAppear {
                    scrollProxy.scrollTo(listVM.currentIndex, anchor: .center)
                }
            }
        }
        .frame(height: Constants.Sizes.carouselHeight)
    }

    @ViewBuilder
    func plusCardView(plusMidX: CGFloat, centerX: CGFloat, scrollProxy: ScrollViewProxy) -> some View {
        Color.clear
            .frame(width: Constants.Sizes.itemWidth, height: Constants.Sizes.itemHeight)
            .onChange(of: plusMidX) { _ in
                let distance = abs(plusMidX - centerX)
                
                if distance < Constants.Threshold.plusSnapBack {
                    withAnimation {
                        scrollProxy.scrollTo(listVM.currentIndex, anchor: .center)
                    }
                }
            }
            .overlay(addCitiesBtn())
    }

    @ViewBuilder
    func carouselItemView(idx: Int, itemMidX: CGFloat, centerX: CGFloat) -> some View {
        let isSelected = listVM.currentIndex == idx
        let distance = abs(itemMidX - centerX)

        VStack(spacing: Constants.Layout.vStackSpacingInner) {
            Circle()
                .fill(listVM.lists[idx].color)
                .frame(width: isSelected ? Constants.Sizes.circleSelected : Constants.Sizes.circleDefault,
                       height: isSelected ? Constants.Sizes.circleSelected : Constants.Sizes.circleDefault)
                .scaleEffect(isSelected ? Constants.Animation.scale : 1.0)
                .animation(.easeInOut(duration: Constants.Animation.duration), value: listVM.currentIndex)

            Text(listVM.lists[idx].shortName)
                .font(Constants.Fonts.caption)
        }
        .onChange(of: itemMidX) { _ in
            if distance < Constants.Threshold.snapSelection {
                listVM.currentIndex = idx
            }
        }
    }
    
    @ViewBuilder
    func addCitiesBtn() -> some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Constants.Colors.addButtonBackground)
                    .frame(width: Constants.Sizes.plusSize, height: Constants.Sizes.plusSize)
                    .overlay(
                        Circle()
                            .stroke(Constants.Colors.addButtonBorder, lineWidth: Constants.Sizes.borderWidth)
                    )
                
                Image(systemName: Constants.Labels.plusIcon)
                    .foregroundColor(Constants.Colors.addButtonIcon)
            }
            Text(Constants.Labels.addTitle)
                .font(Constants.Fonts.caption)
        }
        .frame(width: Constants.Sizes.itemWidth)
        .onTapGesture {
            showNewList = true
        }
    }
}
