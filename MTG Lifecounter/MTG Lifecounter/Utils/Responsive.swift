//
//  Responsive.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 14.06.2025.
//

import SwiftUI

public var isIPad: Bool {
  return UIDevice.current.userInterfaceIdiom == .pad
}

// Grid properties
public var adaptiveGridColumns: Int {
  // Since we're always in landscape, use 3 columns for iPad and landscape iPhone
  return isIPad ? 3 : 3
}

public var adaptiveGridSpacing: CGFloat {
  isIPad ? 16 : 8
}

// Text sizes
public var adaptiveTitleSize: CGFloat {
  isIPad ? 36 : 24  // Always landscape
}

public var adaptiveSubtitleSize: CGFloat {
  isIPad ? 28 : 20  // Always landscape
}

// Spacing
public var adaptiveSpacing: CGFloat {
  isIPad ? 24 : 16
}

// Button/Icon sizes
public var adaptiveIconSize: CGFloat {
  isIPad ? 30 : 24
}

public var adaptiveButtonPadding: CGFloat {
  isIPad ? 16 : 12
}

public var adaptivePadding: EdgeInsets {
  if isIPad {
    return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
  } else {
    return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
  }
}

