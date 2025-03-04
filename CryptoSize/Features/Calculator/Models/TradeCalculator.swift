//
//  TradeCalculator.swift
//  CryptoSize
//
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import Foundation

struct TradeCalculator {
    /// Calculates the position size given the account balance, risk percent, entry price, and stop-loss price.
    /// - Parameters:
    ///   - accountBalance: Total balance in USD.
    ///   - riskPercentage: Risk percentage (e.g- 1 for 1%).
    ///   - entryPrice: Price at which u enter the trade.
    ///   - stopLossPrice: Price at which u will exit the trade to limit loss.
    /// - Returns: The position size (number of coins) to trade.
    static func calculatePositionSize(accountBalance: Double,
                                      riskPercentage: Double,
                                      entryPrice: Double,
                                      stopLossPrice: Double) -> Double {
        let riskAmount = accountBalance * (riskPercentage / 100)
        let perUnitRisk = abs(entryPrice - stopLossPrice)
        return perUnitRisk > 0 ? riskAmount / perUnitRisk : 0
    }
}
