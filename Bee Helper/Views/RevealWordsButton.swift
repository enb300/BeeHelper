import SwiftUI

struct RevealWordsButton: View {
    @Binding var showingAllWords: Bool
    
    var body: some View {
        Button(action: {
            showingAllWords = true
        }) {
            HStack {
                Image(systemName: "eye")
                    .font(.title2)
                
                Text("Show All Words")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RevealWordsButton(showingAllWords: .constant(false))
} 