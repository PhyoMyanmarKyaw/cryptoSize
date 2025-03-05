import SwiftUI

struct ResultCard: View {
    typealias AccentType = Theme.Colors.Accents.AccentType
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let backgroundColor: Color
    let borderColor: Color
    let shadowColor: Color
    let titleFont: Font
    let valueFont: Font
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        value: String,
        backgroundColor: Color,
        borderColor: Color,
        shadowColor: Color,
        titleFont: Font = .subheadline,
        valueFont: Font = .title3
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.titleFont = titleFont
        self.valueFont = valueFont
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Title Section
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(titleFont)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(titleFont)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Value
            Text(value)
                .font(valueFont)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Preset Styles
extension ResultCard {
    static func positionSize(value: String) -> ResultCard {
        ResultCard(
            icon: "dollarsign.circle.fill",
            iconColor: Theme.Colors.Accents.position,
            title: "Position Size",
            value: value,
            backgroundColor: Theme.Colors.Cards.position,
            borderColor: Theme.Colors.Accents.opacity(.position, .border),
            shadowColor: Theme.Colors.Accents.opacity(.position, .shadow),
            titleFont: .headline,
            valueFont: .system(size: 28)
        )
    }
    
    static func risk(value: String, isFullWidth: Bool = false) -> ResultCard {
        ResultCard(
            icon: "exclamationmark.triangle.fill",
            iconColor: Theme.Colors.Accents.risk,
            title: isFullWidth ? "Risk Amount" : "Risk",
            value: value,
            backgroundColor: Theme.Colors.Cards.risk,
            borderColor: Theme.Colors.Accents.opacity(.risk, .border),
            shadowColor: Theme.Colors.Accents.opacity(.risk, .shadow),
            titleFont: isFullWidth ? .headline : .subheadline,
            valueFont: isFullWidth ? .title2 : .title3
        )
    }
    
    static func profit(value: String) -> ResultCard {
        ResultCard(
            icon: "arrow.up.forward.circle.fill",
            iconColor: Theme.Colors.Accents.profit,
            title: "Profit",
            value: value,
            backgroundColor: Theme.Colors.Cards.profit,
            borderColor: Theme.Colors.Accents.opacity(.profit, .border),
            shadowColor: Theme.Colors.Accents.opacity(.profit, .shadow)
        )
    }
    
    static func riskReward(value: String) -> ResultCard {
        ResultCard(
            icon: "arrow.left.arrow.right.circle.fill",
            iconColor: Theme.Colors.Accents.riskReward,
            title: "Risk to Reward",
            value: value,
            backgroundColor: Theme.Colors.Cards.riskReward,
            borderColor: Theme.Colors.Accents.opacity(.riskReward, .border),
            shadowColor: Theme.Colors.Accents.opacity(.riskReward, .shadow)
        )
    }
}
