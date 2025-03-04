import SwiftUI

struct ResultView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
                .font(.headline)
            
            Spacer()
            
            Text(value.isEmpty ? "-" : value)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color(hex: "2A2A2A"))
                .cornerRadius(6)
        }
        .frame(maxWidth: .infinity)
    }
}
