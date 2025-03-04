import SwiftUI

struct InputSection: View {
    @Binding var accountBalance: String
    @Binding var riskPercentage: String
    @Binding var leverage: String
    @Binding var entryPrice: String
    @Binding var stopLossPrice: String
    @Binding var targetPrice: String
    let errorMessage: String
    let isIPad: Bool
    
    // Determine if we should use the two-column layout
    private var useWideLayout: Bool {
        #if os(macOS)
        return true
        #else
        return isIPad
        #endif
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if useWideLayout {
                // iPad Layout - 2 columns
                HStack(alignment: .top, spacing: 20) {
                    // Left Column
                    VStack(spacing: 20) {
                        CustomInputField(title: "Account Balance (USD)", text: $accountBalance)
                        CustomInputField(title: "Risk %", text: $riskPercentage)
                        CustomInputField(title: "Entry Price", text: $entryPrice)
                    }
                    
                    // Right Column
                    VStack(spacing: 20) {
                        CustomInputField(title: "Leverage", text: $leverage)
                        CustomInputField(title: "Stop Loss", text: $stopLossPrice)
                        CustomInputField(title: "Take Profit", text: $targetPrice)
                    }
                }
            } else {
                // iPhone Layout - Single column with split fields
                VStack(spacing: 20) {
                    // Account Balance - Full Width
                    CustomInputField(title: "Account Balance (USD)", text: $accountBalance)
                    
                    // Risk and Leverage
                    HStack(spacing: 15) {
                        CustomInputField(title: "Risk %", text: $riskPercentage)
                        CustomInputField(title: "Leverage", text: $leverage)
                    }
                    
                    // Entry Price - Full Width
                    CustomInputField(title: "Entry Price", text: $entryPrice)
                    
                    // Stop Loss and Take Profit
                    HStack(spacing: 15) {
                        CustomInputField(title: "Stop Loss", text: $stopLossPrice)
                        CustomInputField(title: "Take Profit", text: $targetPrice)
                    }
                }
            }
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Theme.Colors.errorBackground)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Theme.Colors.cardBackground)
        .cornerRadius(useWideLayout ? 16 : 10)
    }
}

#Preview {
    InputSection(
        accountBalance: .constant("10000"),
        riskPercentage: .constant("1"),
        leverage: .constant("10"),
        entryPrice: .constant("50000"),
        stopLossPrice: .constant("49000"),
        targetPrice: .constant("52000"),
        errorMessage: "",
        isIPad: false
    )
    .padding()
    .background(Color.black)
}
