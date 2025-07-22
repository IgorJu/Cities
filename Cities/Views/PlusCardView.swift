import SwiftUI

// MARK: - Constants

private enum Constants {
    static let cornerRadius: CGFloat = 10
    static let strokeColor: Color = .gray
    static let strokeWidth: CGFloat = 2
    static let size: CGFloat = 100
    static let iconName = "plus"
    static let iconColor: Color = .blue
    static let iconFont: Font = .largeTitle
}

// MARK: - PlusCardView
///  Description:
///  Представляет карточку с иконкой "+" в центре. Используется как визуальный элемент
///  для добавления новых сущностей (например, списков).

struct PlusCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Constants.strokeColor, lineWidth: Constants.strokeWidth)
                .frame(width: Constants.size, height: Constants.size)
            
            Image(systemName: Constants.iconName)
                .font(Constants.iconFont)
                .foregroundColor(Constants.iconColor)
        }
    }
}


