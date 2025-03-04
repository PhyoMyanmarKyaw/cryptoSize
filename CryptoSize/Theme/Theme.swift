import SwiftUI

enum Theme {
    enum Colors {
        static let background = Color(hex: "121212")
        static let cardBackground = Color(hex: "1A1A1A")
        static let errorBackground = Color(hex: "2A1A1A")
        
        enum Cards {
            static let position = Color(hex: "2A3A4A")
            static let risk = Color(hex: "391A1A")
            static let profit = Color(hex: "1A392B")
            static let riskReward = Color(hex: "2A2A1A")
        }
        
        enum Accents {
            static let position = Color.blue
            static let risk = Color.red
            static let profit = Color.green
            static let riskReward = Color.yellow
            
            static func opacity(_ accent: Accents.AccentType, _ type: OpacityType) -> Color {
                let color: Color = {
                    switch accent {
                    case .position: return position
                    case .risk: return risk
                    case .profit: return profit
                    case .riskReward: return riskReward
                    }
                }()
                
                switch type {
                case .border: return color.opacity(0.3)
                case .shadow: return color.opacity(0.2)
                }
            }
            
            enum AccentType {
                case position
                case risk
                case profit
                case riskReward
            }
        }
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 14
        static let large: CGFloat = 16
    }
    
    enum FontSize {
        static let title: CGFloat = 28
        static let subtitle: CGFloat = 20
        static let body: CGFloat = 16
        static let caption: CGFloat = 12
    }
}

enum OpacityType {
    case border
    case shadow
}
