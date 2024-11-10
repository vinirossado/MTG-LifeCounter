//
//  User.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 10.11.2024.
//

import Foundation

struct RegistrationData: Codable {
    let playerName: String
    let deckName: String
    let country: String?
}
