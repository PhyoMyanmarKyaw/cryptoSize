import SwiftUI

struct MacContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with proper spacing
                headerView
                    .padding(.top, 34)
                
                
                // Main content with fixed height
                mainContentArea
                    .padding(.bottom, 20)
                
                // Footer with proper spacing
                FooterView()
                    .padding(.bottom, 20)
                
                // Add spacer to push everything up
                Spacer()
            }
            .padding(.horizontal, 30)
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
    
    // MARK: - UI Components
    
    private var headerView: some View {
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
    }
    
    private var mainContentArea: some View {
        HStack(alignment: .top, spacing: 26) {
            tradeParametersSection
            positionResultsSection
        }
        .frame(height: 500)
    }
    
    private var tradeParametersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "Trade Parameters", iconName: "gearshape.2.fill")
            
            // Custom macOS input layout matching iPad but with reordered fields
            VStack(spacing: 14) {
                // Account Balance - Full Width
                CustomInputField(title: "Account Balance (USD)", text: $viewModel.accountBalance)
                
                // Leverage and Risk % (side by side)
                HStack(spacing: 15) {
                    CustomInputField(title: "Leverage", text: $viewModel.leverage)
                    CustomInputField(title: "Risk %", text: $viewModel.riskPercentage)
                }
                
                // Entry Price - Full Width
                CustomInputField(title: "Entry Price", text: $viewModel.entryPrice)
                
                // Stop Loss and Take Profit (side by side)
                HStack(spacing: 15) {
                    CustomInputField(title: "Stop Loss", text: $viewModel.stopLossPrice)
                    CustomInputField(title: "Take Profit", text: $viewModel.targetPrice)
                }
                
                // Error message with fixed height container
                VStack {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.errorBackground)
                            .cornerRadius(8)
                    }
                }
                .frame(height: 36) // Fixed height regardless of content
            }
            .padding()
            .background(Theme.Colors.cardBackground)
            .cornerRadius(16)
        }
        .frame(width: 350)
    }
    
    private var positionResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Position Results", iconName: "chart.bar.fill")
            
            ResultsSection(
                positionSize: viewModel.positionSize,
                riskAmount: viewModel.riskAmount,
                potentialProfit: viewModel.potentialProfit,
                riskRewardRatio: viewModel.riskRewardRatio,
                hasRequiredFields: viewModel.hasRequiredFields,
                hasTargetPrice: !viewModel.targetPrice.isEmpty,
                isIPad: true // Using iPad layout for macOS
            )
        }
        .frame(width: 350)
    }
    
    private func sectionHeader(title: String, iconName: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(.yellow.opacity(0.8))
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MacContentView()
}
