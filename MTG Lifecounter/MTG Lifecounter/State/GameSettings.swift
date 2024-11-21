//
//  GameSettings.swift
//  MTG Lifecounter
//
//  Created by Snowye on 21/11/24.
//

import SwiftUI

class GameSettings: ObservableObject {
    @Published var startingLife: Int = 40;
    @Published var layout: PlayerLayouts = .four;
}
