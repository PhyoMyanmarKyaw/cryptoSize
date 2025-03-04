
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import Foundation

enum TradeError: LocalizedError {
    case invalidAccountBalance
    case invalidRiskPercentage
    case invalidEntryPrice
    case invalidStopLossPrice
    case invalidTargetPrice
    case invalidLeverage
    
    var errorDescription: String? {
        switch self {
        case .invalidAccountBalance:
            return "Account balance must be greater than 0"
        case .invalidRiskPercentage:
            return "Risk percentage must be between 0.1 and 100"
        case .invalidEntryPrice:
            return "Entry price must be greater than 0"
        case .invalidStopLossPrice:
            return "Stop loss must be below entry price"
        case .invalidTargetPrice:
            return "Take profit must be above entry price"
        case .invalidLeverage:
            return "Leverage must be 1 or greater"
        }
    }
}
