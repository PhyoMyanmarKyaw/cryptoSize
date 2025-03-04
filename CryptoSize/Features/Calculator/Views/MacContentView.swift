import SwiftUI

struct MacContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Custom Header with icon
                HStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.yellow)
                    
                    Text("Position Calculator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 30)
                    
                    // Main content area
                    HStack(alignment: .top, spacing: 30) {
                        // Input Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "gearshape.2.fill")
                                    .foregroundColor(.yellow.opacity(0.8))
                                
                                Text("Trade Parameters")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            InputSection(
                                accountBalance: $viewModel.accountBalance,
                                riskPercentage: $viewModel.riskPercentage,
                                leverage: $viewModel.leverage,
                                entryPrice: $viewModel.entryPrice,
                                stopLossPrice: $viewModel.stopLossPrice,
                                targetPrice: $viewModel.targetPrice,
                                errorMessage: viewModel.errorMessage,
                                isIPad: true // This will be ignored on macOS due to our useWideLayout property
                            )
                        }
                        .frame(width: 350)
                        
                        // Results Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.yellow.opacity(0.8))
                                
                                Text("Position Results")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            ResultsSection(
                                positionSize: viewModel.positionSize,
                                riskAmount: viewModel.riskAmount,
                                potentialProfit: viewModel.potentialProfit,
                                riskRewardRatio: viewModel.riskRewardRatio,
                                hasRequiredFields: viewModel.hasRequiredFields,
                                hasTargetPrice: !viewModel.targetPrice.isEmpty,
                                isIPad: true // This will be ignored on macOS due to our useWideLayout property
                            )
                        }
                        .frame(width: 350)
                    }
                    
                    // Footer
                    FooterView()
                        .padding(.bottom, 20)
                }

            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { viewModel.resetAll() }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
}

#Preview {
    MacContentView()
}
