import SwiftUI

struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    
    func contains(_ query: String) -> Bool {
        name.lowercased().contains(query.lowercased())
    }
    
    // Static function to create flag from country code
    static func flagEmoji(for countryCode: String) -> String {
        // Convert country code to regional unicode
        let base: UInt32 = 127397 // 🇦 starts at 127462 (subtracting 65 [ASCII code for A])
        var emoji = ""
        for char in countryCode.uppercased() {
            if let scalar = UnicodeScalar(base + UInt32(char.asciiValue ?? 0)) {
                emoji.append(String(scalar))
            }
        }
        return emoji
    }
}

struct CountryPickerField: View {
    let title: String
    @Binding var selectedCountry: Country?
    @State private var isShowingPicker = false
    @State private var searchText = ""
    
    // List of countries with their flags
    private let countries = [
        Country(name: "Brazil", flag: Country.flagEmoji(for: "BR")),
        Country(name: "Estonia", flag: Country.flagEmoji(for: "EE")),
        Country(name: "Russia", flag: Country.flagEmoji(for: "RU")),
        Country(name: "United Kingdom", flag: Country.flagEmoji(for: "GB")),
        Country(name: "United States", flag: Country.flagEmoji(for: "US")),
        Country(name: "Canada", flag: Country.flagEmoji(for: "CA")),
        Country(name: "Portugal", flag: Country.flagEmoji(for: "PT")),
        Country(name: "Spain", flag: Country.flagEmoji(for: "ES")),
        Country(name: "Germany", flag: Country.flagEmoji(for: "DE")),
        Country(name: "Italy", flag: Country.flagEmoji(for: "IT")),
    ]
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        }
        return countries.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Button(action: {
                isShowingPicker = true
            }) {
                HStack {
                    if let country = selectedCountry {
                        Text("\(country.flag) \(country.name)")
                    } else {
                        Text("Select a country")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.2))
                )
            }
            .sheet(isPresented: $isShowingPicker) {
                NavigationView {
                    List {
                        ForEach(filteredCountries) { country in
                            Button(action: {
                                selectedCountry = country
                                isShowingPicker = false
                            }) {
                                HStack {
                                    Text(country.flag)
                                        .font(.title2)
                                    Text(country.name)
                                    Spacer()
                                    if selectedCountry == country {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search country")
                    .navigationTitle("Select Country")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isShowingPicker = false
                            }
                        }
                    }
                }
            }
        }
    }
}
