//
//  CalculatorViewModel.swift
//  CryptoSize
//
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {
    // Input properties
    @Published var accountBalance: String = "" {
        didSet { checkUserInput() }
    }
    @Published var riskPercentage: String = "" {
        didSet { checkUserInput() }
    }
    @Published var entryPrice: String = "" {
        didSet { checkUserInput() }
    }
    @Published var stopLossPrice: String = "" {
        didSet { checkUserInput() }
    }
    @Published var targetPrice: String = "" {
        didSet { checkUserInput() }
    }
    @Published var leverage: String = "1" {
        didSet { checkUserInput() }
    }
    
    @Published var hasUserInput: Bool = false
    @Published var hasRequiredFields: Bool = false
    
    // Output properties
    @Published var positionSize: String = ""
    @Published var riskAmount: String = ""
    @Published var riskRewardRatio: String = ""
    @Published var potentialProfit: String = ""
    @Published var potentialLoss: String = ""
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Combine all input publishers
        Publishers.CombineLatest(
            Publishers.CombineLatest3($accountBalance, $riskPercentage, $entryPrice),
            Publishers.CombineLatest3($stopLossPrice, $targetPrice, $leverage)
        )
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.calculateTrade()
        }
        .store(in: &cancellables)
    }
    
    func calculateTrade() {
        // Reset error message
        errorMessage = ""
        
        // Validate and convert inputs
        guard let balance = Double(accountBalance),
              let risk = Double(riskPercentage),
              let entry = Double(entryPrice),
              let stopLoss = Double(stopLossPrice),
              let leverageValue = Double(leverage) else {
            errorMessage = "Please enter valid numbers"
            resetOutputs()
            return
        }
        
        // Make targetPrice optional
        let target: Double? = targetPrice.isEmpty ? nil : Double(targetPrice)
        
        do {
            let trade = try Trade.validate(
                accountBalance: balance,
                riskPercentage: risk,
                entryPrice: entry,
                stopLossPrice: stopLoss,
                targetPrice: target,
                leverage: leverageValue
            )
            
            updateOutputs(with: trade)
        } catch let error as TradeError {
            errorMessage = error.localizedDescription
            resetOutputs()
        } catch {
            errorMessage = "An unexpected error occurred"
            resetOutputs()
        }
    }
    
    private func updateOutputs(with trade: Trade) {
        // Position Size
        positionSize = format(number: trade.positionSize)
        
        // Risk Amount
        riskAmount = format(number: trade.riskAmount, prefix: "$")
        
        // Risk/Reward ratio - if set
        if let ratio = trade.riskRewardRatio {
            if ratio.truncatingRemainder(dividingBy: 1) == 0 {
                riskRewardRatio = "1:" + String(format: "%.0f", ratio)
            } else {
                riskRewardRatio = "1:" + String(format: "%.1f", ratio)
            }
        } else {
            riskRewardRatio = ""
        }
        
        // Profit at target - if set
        if let profit = trade.profitAtTarget {
            if profit.truncatingRemainder(dividingBy: 1) == 0 {
                potentialProfit = "$" + String(format: "%.0f", profit)
            } else {
                potentialProfit = format(number: profit, prefix: "$")
            }
        } else {
            potentialProfit = ""
        }
        
        // Loss at stop
        potentialLoss = format(number: trade.lossAtStop, prefix: "-$")
    }
    
    func resetAll() {
        // Reset inputs
        accountBalance = ""
        riskPercentage = ""
        entryPrice = ""
        stopLossPrice = ""
        targetPrice = ""
        leverage = "1"
        
        // Reset outputs and error
        positionSize = ""
        riskAmount = ""
        riskRewardRatio = ""
        potentialProfit = ""
        potentialLoss = ""
        errorMessage = ""
        
        // Reset state
        hasUserInput = false
        hasRequiredFields = false
    }
    
    private func resetOutputs() {
        positionSize = ""
        riskAmount = ""
        riskRewardRatio = ""
        potentialProfit = ""
        potentialLoss = ""
        hasUserInput = false
    }
    
    private func checkUserInput() {
        // Check if user has interacted with any field
        hasUserInput = !accountBalance.isEmpty || !riskPercentage.isEmpty || 
                      !entryPrice.isEmpty || !stopLossPrice.isEmpty || 
                      !targetPrice.isEmpty || leverage != "1"
        
        // Check if we have all required fields with valid numbers
        if let balance = Double(accountBalance),
           let risk = Double(riskPercentage),
           let entry = Double(entryPrice),
           let stop = Double(stopLossPrice),
           balance > 0, risk > 0, entry > 0, stop > 0 {
            hasRequiredFields = true
        } else {
            hasRequiredFields = false
        }
    }
    
    private func format(number: Double, prefix: String = "") -> String {
        guard let formatted = numberFormatter.string(from: NSNumber(value: number)) else {
            return ""
        }
        return prefix + formatted
    }
}
