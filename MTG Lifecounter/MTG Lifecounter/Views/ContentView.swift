import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(hex: "010c1e")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image(systemName: "gamecontroller.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(hex:"d5d9e0"))
                    
                    Spacer().frame(height: 350)
                    
                    GeometryReader { geometry in
                        VStack(spacing: 20) {
                            Button(action: {
                                path.append("GameSetupView")
                            }) {
                                Text("Start Game")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "d5d9e0"))
                                    .padding()
                                    .frame(width: geometry.size.width * 0.50)
                                    .background(Color(hex: "4a6d88"))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                path.append("RegisterView")
                            }) {
                                Text("New Player")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "d5d9e0"))
                                    .padding()
                                    .frame(width: geometry.size.width * 0.50)
                                    .background(Color(hex: "4a6d88"))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                print("Configurações")
                            }) {
                                Text("Configurations")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "d5d9e0"))
                                    .padding()
                                    .frame(width: geometry.size.width * 0.50)
                                    .background(Color(hex: "4a6d88"))
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 150)
                    
                    Spacer()
                }
                .padding()
                .navigationDestination(for: String.self) { view in
                    if view == "GameSetupView" {
                        GameSetupView()
                    }
                    if view == "RegisterView"{
                        RegisterView()
                    }
                }
            }
        }
    }
}
