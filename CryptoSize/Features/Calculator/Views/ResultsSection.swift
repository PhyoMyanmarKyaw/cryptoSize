import SwiftUI

struct ResultsSection: View {
    let positionSize: String
    let riskAmount: String
    let potentialProfit: String
    let riskRewardRatio: String
    let hasRequiredFields: Bool
    let hasTargetPrice: Bool
    let isIPad: Bool
    
    // Determine if we should use the wide layout
    private var useWideLayout: Bool {
        #if os(macOS)
        return true
        #else
        return isIPad
        #endif
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Position Size Card (Full Width)
            ResultCard.positionSize(value: positionSize)
            
            // Risk and Profit Section
            if hasRequiredFields {
                if !hasTargetPrice {
                    // Full-width Risk Card when no TP
                    ResultCard.risk(value: riskAmount, isFullWidth: true)
                } else {
                    // Split Risk and Profit when TP is set
                    HStack(spacing: 15) {
                        ResultCard.risk(value: riskAmount)
                            .frame(maxWidth: .infinity)
                        
                        ResultCard.profit(value: potentialProfit)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Risk/Reward Ratio Card
                    if !riskRewardRatio.isEmpty {
                        ResultCard.riskReward(value: riskRewardRatio)
                    }
                }
            }
        }
        .padding(useWideLayout ? 24 : 16)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(useWideLayout ? 16 : 14)
    }
}

#Preview {
    ResultsSection(
        positionSize: "1.234 BTC",
        riskAmount: "$500",
        potentialProfit: "$1,500",
        riskRewardRatio: "1:3",
        hasRequiredFields: true,
        hasTargetPrice: true,
        isIPad: false
    )
    .padding()
    .background(Color.black)
}
