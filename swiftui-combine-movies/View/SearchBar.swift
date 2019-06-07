import SwiftUI

struct SearchBar: View {
    
    @Binding var input: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            TextField($input, placeholder: Text("Search movie...").color(Color.gray))
                .padding([.leading, .trailing], 8)
                .frame(height: 32)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            
            Button(action: action, label: { Text("Search") })
                .foregroundColor(Color.black)
        }
        .padding([.leading, .trailing], 16)
        .frame(height: 64)
    }
}
