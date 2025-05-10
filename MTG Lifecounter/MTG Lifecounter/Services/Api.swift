//
//  Api.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 10.11.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func registerPlayer(data: PlayerData) async throws -> String {
        guard let url = URL(string: "http://localhost:5010/api/player") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(data)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Received HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)"])
        }
        
        if let message = String(data: data, encoding: .utf8) {
            return message
        } else {
            return "Registration successful!"
        }
    }

    func getPlayers() async throws -> String {
        guard let url = URL(string: "http://localhost:5010/api/player") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Received HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)"])
        }
        
        if let message = String(data: data, encoding: .utf8) {
            return message
        } else {
            return "Players retrieved successfully!"
        }
    }
}
