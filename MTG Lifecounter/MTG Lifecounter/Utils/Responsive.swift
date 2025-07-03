//
//  Responsive.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 14.06.2025.
//

import SwiftUI

// Cached device properties for performance
private struct ResponsiveProperties {
  static let shared = ResponsiveProperties()
  
  let isIPad = UIDevice.current.userInterfaceIdiom == .pad
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  
  // Grid properties
  var adaptiveGridColumns: Int {
    // Since we're always in landscape, use 3 columns for iPad and landscape iPhone
    return isIPad ? 3 : 3
  }

  var adaptiveGridSpacing: CGFloat {
    isIPad ? 16 : 8
  }

  // Text sizes
  var adaptiveTitleSize: CGFloat {
    isIPad ? 36 : 24  // Always landscape
  }

  var adaptiveSubtitleSize: CGFloat {
    isIPad ? 28 : 20  // Always landscape
  }

  // Spacing
  var adaptiveSpacing: CGFloat {
    isIPad ? 24 : 16
  }

  // Button/Icon sizes
  var adaptiveIconSize: CGFloat {
    isIPad ? 30 : 24
  }

  var adaptiveButtonPadding: CGFloat {
    isIPad ? 16 : 12
  }

  var adaptivePadding: EdgeInsets {
    if isIPad {
      return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    } else {
      return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    }
  }
}

// Public interface using cached values
public var isIPad: Bool {
  ResponsiveProperties.shared.isIPad
}

public var adaptiveGridColumns: Int {
  ResponsiveProperties.shared.adaptiveGridColumns
}

public var adaptiveGridSpacing: CGFloat {
  ResponsiveProperties.shared.adaptiveGridSpacing
}

public var adaptiveTitleSize: CGFloat {
  ResponsiveProperties.shared.adaptiveTitleSize
}

public var adaptiveSubtitleSize: CGFloat {
  ResponsiveProperties.shared.adaptiveSubtitleSize
}

public var adaptiveSpacing: CGFloat {
  ResponsiveProperties.shared.adaptiveSpacing
}

public var adaptiveIconSize: CGFloat {
  ResponsiveProperties.shared.adaptiveIconSize
}

public var adaptiveButtonPadding: CGFloat {
  ResponsiveProperties.shared.adaptiveButtonPadding
}

public var adaptivePadding: EdgeInsets {
  ResponsiveProperties.shared.adaptivePadding
}

