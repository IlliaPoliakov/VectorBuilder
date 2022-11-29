//
//  Constatns.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit

enum VectorBuildState {
  case withPoints
  case withLength
}

enum AlertData {
  static let tooMuch = "Oops... Too Much Data!"
  static let bothCases = "You just entered Data for both Cases of creating Vector. Please, choose One."
  
  static let wrongData = "Oops... Wrang data."
  static let wrongDataBody = "Please, check entered data and try again."
}

enum ImageName {
  static let background = "mainSceneBackground2"
  static let vectorHolder = "vectorHolder"
  static let vectorArrow = "arrow"
}

enum Layer {
  static let background: CGFloat = 0
  static let vectorArrow: CGFloat = 1
  static let vector: CGFloat = 2
  static let vectorHolder:CGFloat = 3
  static let actualVector: CGFloat = 4
  static let foreground: CGFloat = 5
}

enum PhysicsCategory {
  static let vectorEnds: UInt32 = 1
}

enum CollectionViewSection {
  case main
}

enum ButtonData {
  static let borderWidth: CGFloat = 2.5
  static let borderColor: UIColor = Colors.mainColorClear
  static let cornerRadius: CGFloat = 10
  static let backgroundColor: UIColor = UIColor(named: "mainColor")!.withAlphaComponent(0.4)
}

enum Colors {
  static let mainColorClear: UIColor = UIColor(named: "mainColor")!
  static let mainColorBackground: UIColor = UIColor(named: "mainColor")!.withAlphaComponent(0.2)
}

