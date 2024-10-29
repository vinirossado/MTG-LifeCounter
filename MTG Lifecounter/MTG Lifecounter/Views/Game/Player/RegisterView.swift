import SwiftUI

struct RegisterView: View {
    @State private var playerName = ""
    @State private var deckName = ""
    @State private var selectedCountry: Country?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var manager = DeviceOrientationManager.shared
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: manager.adaptiveSpacing) {
                        Text("New Player")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, manager.value(portrait: 40, landscape: 60))
                        
                        if manager.isLandscape && manager.isPad {
                            HStack(alignment: .top, spacing: manager.adaptiveSpacing) {
                                formView
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(manager.adaptivePadding)
                        } else {
                            VStack(spacing: manager.adaptiveSpacing) {
                                formView
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(manager.adaptivePadding)
                        }
                        
                        Button(action: submitForm) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: manager.value(portrait: 300, landscape: 400))
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.vertical, manager.adaptiveSpacing)
                    }
                    .frame(maxWidth: manager.value(portrait: 600, landscape: 800))
                    Spacer()
                }
                Spacer()
            }
            .frame(minHeight: manager.height)
        }
        .trackDeviceOrientation() // Aplica o modifier de orientação
        .alert("Registration", isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    var formView: some View {
        VStack(alignment: .center, spacing: manager.value(portrait: 15, landscape: 20)) {
            FormField(title: "Player Name", text: $playerName, placeholder: "Enter player name")
            FormField(title: "Deck Name", text: $deckName, placeholder: "Enter deck name")
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            CountryPickerField(title: "Nationality", selectedCountry: $selectedCountry)
        }
        .frame(width: manager.value(portrait: 300, landscape: 400))
    }
    
    func submitForm() {
        if playerName.isEmpty || deckName.isEmpty {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }
        
        // TODO: Implement actual registration logic
        alertMessage = "Registration successful!"
        showingAlert = true
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
                .previewDevice("iPad Pro (11-inch)")
                .previewInterfaceOrientation(.portrait)
            
            RegisterView()
                .previewDevice("iPad Pro (11-inch)")
                .previewInterfaceOrientation(.landscapeLeft)
            
            RegisterView()
                .previewDevice("iPhone 14 Pro")
        }
    }
}
