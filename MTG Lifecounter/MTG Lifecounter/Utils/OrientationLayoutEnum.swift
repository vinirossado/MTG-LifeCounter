//
//  OrientationLayoutEnum.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI
import UIKit

public enum OrientationLayout {
  case normal
  case inverted
  case left
  case right

  func toAngle() -> Angle {
    switch self {
        case .normal: return Angle(degrees: 0)
        case .right: return Angle(degrees: 90)
        case .inverted: return Angle(degrees: 180)
        case .left: return Angle(degrees: 270)
    }
  }
}
