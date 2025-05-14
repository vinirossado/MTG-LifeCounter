import SwiftUI

struct EditPlayerView: View {
    @Binding var player: Player
    @Environment(\.presentationMode) var presentationMode
    
    @State private var playerName: String = ""
    
    var body: some View {
       
            VStack(alignment: .center, spacing: 20) {
                Text("Edit Player Name")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Enter new name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
                    .autocapitalization(.words)
                
                HStack(spacing: 20) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: 30)
                            .padding()
                            .background(Color(hex: "E53935"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        player.name = playerName
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .frame(maxWidth: 30)
                            .padding()
                            .background(Color(hex: "4CAF50"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding([.leading, .trailing])
        }
    }
}

struct EditPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius" )))
    }
}
#Preview {
    EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius",)))
}
