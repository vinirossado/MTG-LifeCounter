import SwiftUI
import UniformTypeIdentifiers

struct RegisterView: View {
    @State private var playerName = ""
    @State private var deckName = ""
    @State private var strategy = ""
    @State private var selectedCountry: Country?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isFileImporterPresented = false
    @State private var isLoading = false // For LoadingOverlay
    
    @State private var manager = DeviceOrientationManager.shared
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                // Title
                Text("Register New Player")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, manager.value(portrait: 40, landscape: 60))
                
                VStack(alignment: .center, spacing: 20) {
                    // Form with shadow and rounded corners
                    formView
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                    
                    // Buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            isFileImporterPresented = true
                        }) {
                            Text("Import from File")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Button(action: getUser) {
                            Text("Get User")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Button(action: submitForm) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .frame(minHeight: manager.height)
        }
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.plainText]) { result in
            handleFileImport(result: result)
        }
        .alert("Registration", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
        .loadingOverlay(isShowing: $isLoading, message: "Processing...") // LoadingOverlay
    }
    
    // Form View
    var formView: some View {
        VStack(alignment: .leading, spacing: 20) {
            FormField(title: "Player Name *", text: $playerName, placeholder: "Enter player name")
            FormField(title: "Deck Name *", text: $deckName, placeholder: "Enter deck name")
            FormField(title: "Strategy *", text: $strategy, placeholder: "Enter your deck strategy")

            CountryPickerField(title: "Nationality", selectedCountry: $selectedCountry)
        }
        .padding(20)
    }
    
    // File Import Handler
    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            do {
                // Explicitly specify the encoding
                let contents = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = contents.components(separatedBy: "\n")
                if lines.count >= 2 {
                    playerName = lines[0]
                    deckName = lines[1]
                    alertMessage = "File imported successfully!"
                } else {
                    alertMessage = "File format incorrect. First line: player name, second line: deck name."
                }
            } catch {
                alertMessage = "Failed to read file contents: \(error.localizedDescription)"
            }
            showingAlert = true
        case .failure(let error):
            alertMessage = "Failed to import file: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    func getUser() {
        isLoading = true // Show loading
        NetworkManager.shared.getPlayers { result in
            DispatchQueue.main.async {
                isLoading = false // Hide loading
                if case .success(let players) = result {
                    print(players)
                } else if case .failure(let error) = result {
                    alertMessage = "Failed to fetch users: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
    
    func submitForm() {
        if playerName.isEmpty || deckName.isEmpty {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        let country = selectedCountry?.name
        let registrationData = PlayerData(name: playerName, deckName: deckName, nationality: country)
        
        isLoading = true // Show loading
        NetworkManager.shared.registerPlayer(data: registrationData) { result in
            DispatchQueue.main.async {
                isLoading = false // Hide loading
                switch result {
                case .success(let message):
                    alertMessage = message
                case .failure(let error):
                    alertMessage = "Failed to register: \(error.localizedDescription)"
                }
                showingAlert = true
            }
        }
    }
}

// Form Field View
struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

// Preview
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
                .previewDevice("iPad Pro (11-inch)")
                .previewInterfaceOrientation(.portrait)
            
            RegisterView()
                .previewDevice("iPhone 14 Pro")
        }
    }
}
