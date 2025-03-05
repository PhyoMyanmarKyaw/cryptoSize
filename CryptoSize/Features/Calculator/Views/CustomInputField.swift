import SwiftUI

struct CustomInputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .padding(12)
                .background(Color(hex: "222222"))
                .cornerRadius(Theme.CornerRadius.small)
                .foregroundColor(.white)
                #if os(iOS)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                #else
                // macOS specific style
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .controlSize(.large)
                #endif
        }
    }
}

#Preview {
    CustomInputField(title: "Account Balance", text: .constant("10000"))
        .padding()
        .background(Color.black)
}
