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
    
    func registerPlayer(data: PlayerData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5010/api/player") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response from server", code: 0, userInfo: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received HTTP \(httpResponse.statusCode)"])
                completion(.failure(statusError))
                return
            }
            
            if let data = data, let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.success("Registration successful!"))
            }
        }.resume()
    }

    func getPlayers(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:5010/api/player") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response from server", code: 0, userInfo: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received HTTP \(httpResponse.statusCode)"])
                completion(.failure(statusError))
                return
            }
            
          
            if let data = data, let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.success("Registration successful!"))
            }
        }.resume()
    }
}
