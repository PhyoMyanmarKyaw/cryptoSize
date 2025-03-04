import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HeaderView()
                
                // Input Section
                InputSection(
                    accountBalance: $viewModel.accountBalance,
                    riskPercentage: $viewModel.riskPercentage,
                    leverage: $viewModel.leverage,
                    entryPrice: $viewModel.entryPrice,
                    stopLossPrice: $viewModel.stopLossPrice,
                    targetPrice: $viewModel.targetPrice,
                    errorMessage: viewModel.errorMessage,
                    isIPad: isIPad
                )
                .padding(.horizontal)
                
                // Results Section
                ResultsSection(
                    positionSize: viewModel.positionSize,
                    riskAmount: viewModel.riskAmount,
                    potentialProfit: viewModel.potentialProfit,
                    riskRewardRatio: viewModel.riskRewardRatio,
                    hasRequiredFields: viewModel.hasRequiredFields,
                    hasTargetPrice: !viewModel.targetPrice.isEmpty,
                    isIPad: isIPad
                )
                .padding(.horizontal)
                
                if isIPad {
                    FooterView()
                }
            }
            .padding(.vertical, 24)
        }
    }
}
