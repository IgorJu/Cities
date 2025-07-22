import SwiftUI

//MARK: - Constants

private enum Constants {
    enum Layout {
        static let cornerRadius: CGFloat = 10
        static let cardSize: CGFloat = 100
    }

    enum Colors {
        static let text: Color = .white
    }
}

//MARK: - ListCardView
///  Description:
///  Отображает карточку списка города в виде прямоугольника с цветным фоном
///  и коротким названием. Используется в карусели списков на главном экране.

struct ListCardView: View {
    let list: CityList

    var body: some View {
        content()
    }
}

//MARK: - Private extension UI

private extension ListCardView {
    @ViewBuilder
    func content() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                .fill(list.color)
                .frame(width: Constants.Layout.cardSize,
                       height: Constants.Layout.cardSize)

            Text(list.shortName)
                .foregroundColor(Constants.Colors.text)
                .fontWeight(.bold)
        }
    }
}
