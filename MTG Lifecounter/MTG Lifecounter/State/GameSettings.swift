//
//  GameSettings.swift
//  MTG Lifecounter
//
//  Created by Snowye on 21/11/24.
//

import SwiftUI

public class GameSettings: ObservableObject {
    @Published public var startingLife: Int = 40;
    @Published public var layout: PlayerLayouts = .four;
}
