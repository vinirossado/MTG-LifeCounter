// import SwiftUI

// struct PlayerRegistrationView: View {
//     @EnvironmentObject private var playerState: PlayerState
//     @State private var newPlayerName = ""
    
//     var body: some View {
//         ZStack {
//             // Background
//             LinearGradient(
//                 gradient: Gradient(colors: [.darkNavyBackground, .oceanBlueBackground]),
//                 startPoint: .top,
//                 endPoint: .bottom
//             )
//             .ignoresSafeArea()
            
//             ScrollView {
//                 VStack(spacing: 30) {
//                     Spacer()
                    
//                     // Title
//                     Text("Register New Player")
//                         .font(.largeTitle)
//                         .fontWeight(.bold)
//                         .foregroundColor(.lightGrayText)
//                         .padding(.top, 40)
                    
//                     // Form for existing players
//                     ForEach(playerState.players.indices, id: \.self) { index in
//                         HStack {
//                             TextField("Player \(index + 1)", text: self.$playerState.players[index].name)
//                                 .textFieldStyle(RoundedBorderTextFieldStyle())
                            
//                             Button(action: {
//                                 playerState.players.remove(at: index)
//                             }) {
//                                 Image(systemName: "xmark.circle.fill")
//                                     .foregroundColor(.red)
//                             }
//                         }
//                     }
                    
//                     // Form for new player
//                     TextField("Enter new player name", text: $newPlayerName)
//                         .textFieldStyle(RoundedBorderTextFieldStyle())
                    
//                     Button(action: {
//                         if !newPlayerName.isEmpty {
//                             let newPlayer = Player(HP: 20, name: newPlayerName) // Assuming starting HP is 20
//                             playerState.players.append(newPlayer)
//                             newPlayerName = ""
//                         }
//                     }) {
//                         Text("Add Player")
//                             .padding()
//                             .background(Color.blue)
//                             .foregroundColor(.white)
//                             .cornerRadius(8)
//                     }
                    
//                     Spacer()
//                 }
//             }
//         }
//     }
// }