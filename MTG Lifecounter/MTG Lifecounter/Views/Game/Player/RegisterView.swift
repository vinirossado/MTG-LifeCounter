import SwiftUI
import UniformTypeIdentifiers

struct PlayerRegistrationView: View {
    @State private var playerName = ""
    @State private var deckName = ""
    @State private var strategy = ""
    @State private var selectedCountry: Country?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isFileImporterPresented = false
    @State private var isLoading = false
    
    @State private var manager = DeviceOrientationManager.shared
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.darkNavyBackground, .oceanBlueBackground]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Title
                    Text("Register New Player")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.lightGrayText)
                        .padding(.top, manager.value(portrait: 40, landscape: 60))
                    
                    // Form
                    formView
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.steelGrayBackground.opacity(0.8))
                        )
                        .padding(.horizontal, 20)
                        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 5)
                    
                    // Buttons
                    VStack(spacing: 15) {
                        actionButton(
                            title: "Import from File",
                            icon: "doc.badge.plus",
                            color: Color.green
                        ) {
                            isFileImporterPresented = true
                        }
                        
                        actionButton(
                            title: "Get User",
                            icon: "person.crop.circle.fill.badge.plus",
                            color: Color.blue
                        ) {
                            getUser()
                        }
                        
                        actionButton(
                            title: "Register",
                            icon: "checkmark.circle.fill",
                            color: Color.blue
                        ) {
                            submitForm()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.vertical, 40)
            }
            .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.plainText]) { result in
                handleFileImport(result: result)
            }
            .alert("Registration", isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
                    .foregroundColor(.mutedSilverText)
            }
        }
        .loadingOverlay(isShowing: $isLoading, message: "Processing...") // Custom Loading
    }
    
    // Form View
    var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Player Name *", text: $playerName, placeholder: "Enter player name")
            FormField(title: "Deck Name *", text: $deckName, placeholder: "Enter deck name")
            FormField(title: "Strategy *", text: $strategy, placeholder: "Enter your deck strategy")
            CountryPickerField(title: "Nationality", selectedCountry: $selectedCountry)
        }
        .padding(20)
    }
    
    // Action Button
    @ViewBuilder
    func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color.opacity(0.8), color]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
    
    // File Import Handler
    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            do {
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
        isLoading = true
        Task {
            do {
                let players = try await NetworkManager.shared.getPlayers()
                DispatchQueue.main.async {
                    isLoading = false
                    print(players)
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
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
        
        isLoading = true
        Task {
            do {
                let message = try await NetworkManager.shared.registerPlayer(data: registrationData)
                DispatchQueue.main.async {
                    isLoading = false
                    alertMessage = message
                    showingAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    alertMessage = "Failed to register: \(error.localizedDescription)"
                    showingAlert = true
                }
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
                .foregroundColor(.lightGrayText)
            
            TextField(placeholder, text: $text)
                .padding(12)
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.mutedSilverText, lineWidth: 1)
                )
        }
    }
}

// Preview
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerRegistrationView()
                .previewDevice("iPad Pro (11-inch)")
                .previewInterfaceOrientation(.portrait)
            
            PlayerRegistrationView()
                .previewDevice("iPhone 14 Pro")
        }
    }
}
