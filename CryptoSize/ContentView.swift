//
//  ContentView.swift
//  CryptoSize
//
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import SwiftUI
import Combine

struct ContentView: View {

    @StateObject private var viewModel = CalculatorViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        ZStack(alignment: .top) {
            // Orientation change listener
            let _ = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .makeConnectable()
                .autoconnect()
                .sink { _ in
                    orientation = UIDevice.current.orientation
                }
            Color(hex: "121212")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Custom header
                HStack {
                    Text("Position Calculator")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: viewModel.resetAll) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Theme.Colors.background)
                
                if horizontalSizeClass == .regular {
                    
                    iPadLayout
                    
                    // Footer
                    Text("Be careful of leverage. It can go against you - Walter Schloss")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)
                } else {
                    iPhoneLayout
                }
            }
        }
    }
    
    private var iPadLayout: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Crypto Position Size Calculator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
                
                HStack(alignment: .top, spacing: 30) {
                    // Input Section
                    VStack(spacing: 20) {
                        // Section Title
                        HStack(spacing: 10) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Trade Parameters")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        // Account Balance - Full Width
                        InputField(title: "Account Balance (USD)", text: $viewModel.accountBalance)
                        
                        // Risk and Leverage
                        HStack(spacing: 15) {
                            InputField(title: "Risk %", text: $viewModel.riskPercentage)
                            InputField(title: "Leverage", text: $viewModel.leverage)
                        }
                        
                        // Entry Price - Full Width
                        InputField(title: "Entry Price", text: $viewModel.entryPrice)
                        
                        // Stop Loss and Take Profit
                        HStack(spacing: 15) {
                            InputField(title: "Stop Loss", text: $viewModel.stopLossPrice)
                            InputField(title: "Take Profit", text: $viewModel.targetPrice)
                        }
                        
                        // Error message
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
                    .padding(24)
                    .background(Theme.Colors.cardBackground)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    
                    // Results Section
                    VStack(spacing: 20) {
                        // Section Title
                        HStack(spacing: 10) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            Text("Position Results")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        
                        iPadResultsSection
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 32)
                .frame(maxWidth: 1200)
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 24)
        }
    }
    
    private var iPadResultsSection: some View {
        VStack(spacing: 24) {
            // Position Size Card (Full Width)
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("Position Size")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                Text(viewModel.positionSize)
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 4)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "2A3A4A"))
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.blue.opacity(0.4), lineWidth: 1.5)
            )
            
            // Risk and Profit Section
            Group {
                if !viewModel.hasRequiredFields {
                    EmptyView()
                } else if viewModel.targetPrice.isEmpty {
                    // Full-width Risk Card when no TP
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("Risk Amount")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Text(viewModel.riskAmount)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "391A1A"))
                            .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                    )
                } else {
                    // Split Risk and Profit when TP is set
                    HStack(spacing: 20) {
                        // Risk Card
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.title3)
                                    .foregroundColor(.red)
                                Text("Risk Amount")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            
                            Text(viewModel.riskAmount)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "391A1A"))
                                .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Profit Card
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "arrow.up.forward.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.green)
                                Text("Profit Target")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            
                            Text(viewModel.potentialProfit)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "1A392B"))
                                .shadow(color: Color.green.opacity(0.2), radius: 8, x: 0, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.green.opacity(0.3), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Risk/Reward Ratio Card
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.title3)
                                .foregroundColor(.yellow)
                            Text("Risk to Reward Ratio")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        HStack(spacing: 8) {
                            Text("1")
                                .foregroundColor(.red)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(":")
                                .foregroundColor(.white)
                                .font(.title2)
                            Text(viewModel.riskRewardRatio.replacingOccurrences(of: "1:", with: ""))
                                .foregroundColor(.green)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "2A2A1A"))
                            .shadow(color: Color.yellow.opacity(0.2), radius: 8, x: 0, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding(24)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(16)
    }
    
    private var iPhoneLayout: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Input Section
                VStack(spacing: 20) {
                    // Account Balance - Full Width
                    InputField(title: "Account Balance (USD)", text: $viewModel.accountBalance)
                    
                    // Risk and Leverage
                    HStack(spacing: 15) {
                        InputField(title: "Risk %", text: $viewModel.riskPercentage)
                        InputField(title: "Leverage", text: $viewModel.leverage)
                    }
                    
                    // Entry Price - Full Width
                    InputField(title: "Entry Price", text: $viewModel.entryPrice)
                    
                    // Stop Loss and Take Profit
                    HStack(spacing: 15) {
                        InputField(title: "Stop Loss", text: $viewModel.stopLossPrice)
                        InputField(title: "Take Profit", text: $viewModel.targetPrice)
                    }
                    
                    // Error message
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
                .padding()
                .background(Theme.Colors.cardBackground)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Results Section
                iPhoneResultsSection
                    .padding(.bottom)
            }
            .padding(.vertical, 16)
        }
    }
    
    private var iPhoneResultsSection: some View {
        VStack(spacing: 20) {
            // Position Size Card (Full Width)
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("Position Size")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text(viewModel.positionSize)
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 4)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "2A3A4A"))
                    .shadow(color: Color.blue.opacity(0.2), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1.5)
            )
            
            // Risk and Profit Section
            Group {
                if !viewModel.hasRequiredFields {
                    EmptyView()
                } else if viewModel.targetPrice.isEmpty {
                    // Full-width Risk Card when no TP
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("Risk Amount")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(viewModel.riskAmount)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "391A1A"))
                            .shadow(color: Color.red.opacity(0.15), radius: 6, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.red.opacity(0.25), lineWidth: 1)
                    )
                } else {
                    // Split Risk and Profit when TP is set
                    HStack(spacing: 15) {
                        // Risk Card
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                Text("Risk")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text(viewModel.riskAmount)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "391A1A"))
                                .shadow(color: Color.red.opacity(0.15), radius: 6, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.red.opacity(0.25), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Profit Card
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.forward.circle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                Text("Profit")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text(viewModel.potentialProfit)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "1A392B"))
                                .shadow(color: Color.green.opacity(0.15), radius: 6, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.green.opacity(0.25), lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Risk/Reward Ratio Card
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                            Text("Risk to Reward")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack(spacing: 6) {
                            Text("1")
                                .foregroundColor(.red)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(":")
                                .foregroundColor(.white)
                                .font(.title3)
                            Text(viewModel.riskRewardRatio.replacingOccurrences(of: "1:", with: ""))
                                .foregroundColor(.green)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "2A2A1A"))
                            .shadow(color: Color.yellow.opacity(0.15), radius: 6, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.yellow.opacity(0.25), lineWidth: 1)
                    )
                }
            }
        }
        .padding(16)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(14)
    }
    
    private var resultsSection: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 15) {
                // Position Size Card (Full Width)
                VStack(spacing: 8) {
                    Text("Position Size")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(viewModel.positionSize)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.top, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "2A3A4A"))
                        .shadow(color: Color.blue.opacity(0.2), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                )
                
                // Risk and Profit Section
                Group {
                    if !viewModel.hasRequiredFields {
                        EmptyView()
                    } else if viewModel.targetPrice.isEmpty {
                        // Full-width Risk Card when no TP
                        VStack(spacing: 8) {
                            Text("Risk")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(viewModel.riskAmount)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "391A1A"))
                        .cornerRadius(12)
                    } else {
                        // Split Risk and Profit when TP is set
                        HStack(spacing: 15) {
                            VStack(spacing: 8) {
                                Text("Risk")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(viewModel.riskAmount)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "391A1A"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 8) {
                                Text("Profit Target")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(viewModel.potentialProfit)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "1A392B"))
                            .cornerRadius(12)
                        }
                        
                        // Enhanced Risk/Reward Card
                        HStack(spacing: 4) {
                            Text("Risk to Reward")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 4) {
                                Text("1")
                                    .foregroundColor(.red)
                                Text(":")
                                Text(viewModel.riskRewardRatio.replacingOccurrences(of: "1:", with: ""))
                                    .foregroundColor(.green)
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "2A2A2A"), Color(hex: "1E1E1E")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
            
            // Error message at bottom
            if !viewModel.errorMessage.isEmpty && viewModel.hasUserInput {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color(hex: "121212")
                            .edgesIgnoringSafeArea(.bottom)
                    )
            }
        }
        .background(Theme.Colors.background)
        .navigationTitle("Position Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.resetAll) {
                    
                        Image(systemName: "arrow.counterclockwise")
                       
                }
            }
        }
    }
}

struct DarkGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
                .padding(.bottom, 5)
            configuration.content
        }
        .padding()
        .background(Color(hex: "1E1E1E"))
        .cornerRadius(10)
    }
}
struct InputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
                .font(.headline)
            
            HStack(spacing: 12) {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text("Enter \(title.lowercased())")
                            .foregroundColor(Color.white.opacity(0.3))
                    }
                    .padding(12)
                    .background(Color(hex: "2A2A2A"))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        self.init(
            red: Double((rgbValue >> 16) & 0xFF) / 255.0,
            green: Double((rgbValue >> 8) & 0xFF) / 255.0,
            blue: Double(rgbValue & 0xFF) / 255.0
        )
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
