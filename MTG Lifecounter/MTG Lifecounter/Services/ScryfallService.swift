//
//  ScryfallService.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado 26.06.2025.
//

import Foundation
import SwiftUI

// MARK: - Scryfall API Models
struct ScryfallCard: Codable, Identifiable {
    let id: String
    let name: String
    let type_line: String
    let colors: [String]?
    let color_identity: [String]?
    let image_uris: ImageURIs?
    let card_faces: [CardFace]?
    let legalities: [String: String]?
    let mana_cost: String?
    let cmc: Double?
    
    struct ImageURIs: Codable {
        let small: String?
        let normal: String?
        let large: String?
        let art_crop: String?
        let border_crop: String?
    }
    
    struct CardFace: Codable {
        let name: String
        let type_line: String
        let image_uris: ImageURIs?
        let colors: [String]?
        let mana_cost: String?
    }
    
    // Helper computed properties
    var isCommander: Bool {
        guard let legalities = legalities else { return false }
        return legalities["commander"] == "legal"
    }
    
    var isLegendaryCreature: Bool {
        return type_line.lowercased().contains("legendary") && type_line.lowercased().contains("creature")
    }
    
    var canBeCommander: Bool {
        return isCommander && (isLegendaryCreature || type_line.lowercased().contains("planeswalker"))
    }
    
    var artworkURL: String? {
        return image_uris?.art_crop ?? card_faces?.first?.image_uris?.art_crop
    }
    
    var imageURL: String? {
        return image_uris?.normal ?? card_faces?.first?.image_uris?.normal
    }
    
    var displayColors: [String] {
        return color_identity ?? colors ?? []
    }
}

struct ScryfallSearchResponse: Codable {
    let data: [ScryfallCard]
    let has_more: Bool
    let total_cards: Int
}

// MARK: - Scryfall Service
@MainActor
class ScryfallService: ObservableObject {
    static let shared = ScryfallService()
    
    private let baseURL = "https://api.scryfall.com"
    private let session = URLSession.shared
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // Search for commanders by name
    func searchCommanders(query: String) async throws -> [ScryfallCard] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        // Search for legendary creatures and planeswalkers that can be commanders
        // Use a more flexible search that includes partial name matches
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let searchQuery = "q=is%3Acommander+\(encodedQuery)"
        let urlString = "\(baseURL)/cards/search?\(searchQuery)&format=json&include_multilingual=false&include_variations=false&order=name&dir=asc&unique=cards"
        
        print("🔍 Searching commanders with query: '\(query)'")
        print("🌐 Request URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL created")
            throw ScryfallError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Response Status: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 404 {
                        print("📭 No results found for query: '\(query)'")
                        return [] // No results found
                    }
                    print("❌ HTTP Error: \(httpResponse.statusCode)")
                    throw ScryfallError.httpError(httpResponse.statusCode)
                }
            }
            
            let searchResponse = try JSONDecoder().decode(ScryfallSearchResponse.self, from: data)
            let commanders = searchResponse.data.filter { $0.canBeCommander }
            print("✅ Found \(commanders.count) commanders for query: '\(query)'")
            
            // Debug: Print first few commander names
            for (index, commander) in commanders.prefix(3).enumerated() {
                print("   \(index + 1). \(commander.name) - Image: \(commander.imageURL ?? "none")")
            }
            
            return commanders
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw ScryfallError.decodingError
        } catch {
            print("Network error: \(error)")
            throw ScryfallError.networkError(error)
        }
    }
    
    // Get popular commanders (featured/trending)
    func getFeaturedCommanders() async throws -> [ScryfallCard] {
        isLoading = true
        errorMessage = nil
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        // Search for popular commanders
        let searchQuery = "q=is%3Acommander+type%3Alegendary+type%3Acreature&order=edhrec&dir=desc"
        let urlString = "\(baseURL)/cards/search?\(searchQuery)&format=json&page=1"
        
        print("🌟 Fetching featured commanders")
        print("🌐 Featured URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid featured commanders URL")
            throw ScryfallError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Featured commanders HTTP Response: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    print("❌ Featured commanders HTTP Error: \(httpResponse.statusCode)")
                    throw ScryfallError.httpError(httpResponse.statusCode)
                }
            }
            
            let searchResponse = try JSONDecoder().decode(ScryfallSearchResponse.self, from: data)
            let featuredCommanders = Array(searchResponse.data.prefix(20)) // Limit to top 20
            print("✅ Found \(featuredCommanders.count) featured commanders")
            
            // Debug: Print first few featured commander names
            for (index, commander) in featuredCommanders.prefix(3).enumerated() {
                print("   Featured \(index + 1). \(commander.name) - Image: \(commander.imageURL ?? "none")")
            }
            
            return featuredCommanders
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw ScryfallError.decodingError
        } catch {
            print("Network error: \(error)")
            throw ScryfallError.networkError(error)
        }
    }
    
    // Get random commander for inspiration
    func getRandomCommander() async throws -> ScryfallCard? {
        isLoading = true
        errorMessage = nil
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let urlString = "\(baseURL)/cards/random?q=is%3Acommander+type%3Alegendary"
        
        guard let url = URL(string: urlString) else {
            throw ScryfallError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    throw ScryfallError.httpError(httpResponse.statusCode)
                }
            }
            
            let card = try JSONDecoder().decode(ScryfallCard.self, from: data)
            return card.canBeCommander ? card : nil
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw ScryfallError.decodingError
        } catch {
            print("Network error: \(error)")
            throw ScryfallError.networkError(error)
        }
    }
}

// MARK: - Error Types
enum ScryfallError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(Int)
    case decodingError
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .noResults:
            return "No commanders found"
        }
    }
}

// MARK: - Commander Selection View Model
@MainActor
class CommanderSelectionViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet {
            // Auto-search with debouncing
            searchDebounceTask?.cancel()
            searchDebounceTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                if !Task.isCancelled {
                    await MainActor.run {
                        searchCommanders()
                    }
                }
            }
        }
    }
    @Published var searchResults: [ScryfallCard] = []
    @Published var featuredCommanders: [ScryfallCard] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    
    private let scryfallService = ScryfallService.shared
    private var searchTask: Task<Void, Never>?
    private var searchDebounceTask: Task<Void, Error>?
    
    init() {
        loadFeaturedCommanders()
    }
    
    func searchCommanders() {
        // Cancel previous search
        searchTask?.cancel()
        
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            searchResults = []
            errorMessage = nil
            return
        }
        
        // Require at least 2 characters for search to reduce noise
        guard trimmedQuery.count >= 2 else {
            searchResults = []
            errorMessage = "Enter at least 2 characters to search"
            return
        }
        
        searchTask = Task {
            do {
                isSearching = true
                errorMessage = nil
                
                let results = try await scryfallService.searchCommanders(query: trimmedQuery)
                
                if !Task.isCancelled {
                    searchResults = results
                    if results.isEmpty {
                        errorMessage = "No commanders found for '\(trimmedQuery)'. Try a different search term."
                    } else {
                        errorMessage = nil
                    }
                }
            } catch {
                if !Task.isCancelled {
                    if case ScryfallError.networkError = error {
                        errorMessage = "Network error. Please check your connection and try again."
                    } else {
                        errorMessage = "Search failed: \(error.localizedDescription)"
                    }
                    searchResults = []
                }
            }
            
            if !Task.isCancelled {
                isSearching = false
            }
        }
    }
    
    private func loadFeaturedCommanders() {
        Task {
            do {
                featuredCommanders = try await scryfallService.getFeaturedCommanders()
            } catch {
                print("Failed to load featured commanders: \(error)")
            }
        }
    }
    
    func selectRandomCommander() async -> ScryfallCard? {
        do {
            return try await scryfallService.getRandomCommander()
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
