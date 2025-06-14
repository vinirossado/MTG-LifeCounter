//
//  DefaultStyle.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

struct Style {
  var background: Color
  var foreground: Color
  var opacity: Double
  var hoverOpacity: Double
}

let DEFAULT_STYLES = Style(
  background: .oceanBlueBackground,
  foreground: .lightGrayText,
  opacity: 1,
  hoverOpacity: 0.75
)
