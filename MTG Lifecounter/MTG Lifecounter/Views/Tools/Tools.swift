//
//  Tools.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

// Model for MTG-themed tool items
struct MTGToolItem: Identifiable {
    let id: Int
    let iconName: String
    let label: String
    let description: String
    let magicalEffect: String
}
