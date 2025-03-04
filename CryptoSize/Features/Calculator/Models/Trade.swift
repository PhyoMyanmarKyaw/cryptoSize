//  CryptoSize
//
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import Foundation

struct Trade {
    let accountBalance: Double
    let riskPercentage: Double
    let entryPrice: Double
    let stopLossPrice: Double
    let targetPrice: Double?
    let leverage: Double
    
    // Risk amount in USD
    var riskAmount: Double {
        accountBalance * (riskPercentage / 100)
    }
    
    // Position size calculation
    var positionSize: Double {
        let riskPerTrade = abs(entryPrice - stopLossPrice)
        return (riskAmount / riskPerTrade) * leverage
    }
    
    // Risk to Reward ratio
    var riskRewardRatio: Double? {
        guard let targetPrice = targetPrice else { return nil }
        let risk = abs(entryPrice - stopLossPrice)
        let reward = abs(targetPrice - entryPrice)
        return reward / risk
    }
    
    // Profit at target price (if set)
    var profitAtTarget: Double? {
        guard let targetPrice = targetPrice else { return nil }
        // For long positions (entry < target)
        if entryPrice < targetPrice {
            return positionSize * (targetPrice - entryPrice)
        }
        // For short positions (entry > target)
        else {
            return positionSize * (entryPrice - targetPrice)
        }
    }
    
    // Loss at stop loss (this will equal riskAmount)
    var lossAtStop: Double {
        positionSize * abs(entryPrice - stopLossPrice)
    }
}

extension Trade {
    static func validate(accountBalance: Double,
                        riskPercentage: Double,
                        entryPrice: Double,
                        stopLossPrice: Double,
                        targetPrice: Double?,
                        leverage: Double) throws -> Trade {
        
        guard accountBalance > 0 else {
            throw TradeError.invalidAccountBalance
        }
        
        guard (0.1...100).contains(riskPercentage) else {
            throw TradeError.invalidRiskPercentage
        }
        
        guard entryPrice > 0 else {
            throw TradeError.invalidEntryPrice
        }
        
        guard stopLossPrice > 0 else {
            throw TradeError.invalidStopLossPrice
        }
        
        guard leverage >= 1 else {
            throw TradeError.invalidLeverage
        }
        
        if let tp = targetPrice {
            // For long positions: entry > sl && target > entry
            if entryPrice > stopLossPrice {
                guard tp > entryPrice else {
                    throw TradeError.invalidTargetPrice
                }
            }
            // For short positions: entry < sl && target < entry
            else {
                guard tp < entryPrice else {
                    throw TradeError.invalidTargetPrice
                }
            }
        }
        
        return Trade(accountBalance: accountBalance,
                    riskPercentage: riskPercentage,
                    entryPrice: entryPrice,
                    stopLossPrice: stopLossPrice,
                    targetPrice: targetPrice,
                    leverage: leverage)
    }
}
