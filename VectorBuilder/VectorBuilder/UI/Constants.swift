//
//  Constatns.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit

enum CollectionViewSection {
  case main
}

enum Colors {
  case mainColorClear
  case mainColorBackground
  
  func color() -> UIColor {
    switch self {
    case .mainColorClear:
      return UIColor(named: "mainColor")!
      
    case .mainColorBackground:
      return UIColor(named: "mainColor")!.withAlphaComponent(0.2)
    }
  }
}
