import SwiftUI

struct EditPlayerView: View {
    @Binding var player: Player
    
    @State private var playerName = ""
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Text Field for Player Name
                TextField("Player Name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Image Selection
//                HStack {
//                    if let image = selectedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                    } else {
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(width: 100, height: 100)
//                            .overlay(
//                                Text("Select Image")
//                                    .foregroundColor(.gray)
//                            )
//                    }
//                    
//                    Button(action: {
//                        // Logic to select an image
//                    }) {
//                        Text("Select Image")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                
                Spacer()
                
                // Save Button
                Button(action: {
                    player.name = playerName
                    // Add logic to save the selected image if needed
                    dismissSheet()
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Edit Player")
            .navigationBarItems(trailing: Button(action: { dismissSheet() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            })
        }
        .onAppear {
            playerName = player.name
        }
    }
    
    private func dismissSheet() {
        // Dismiss the sheet
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
