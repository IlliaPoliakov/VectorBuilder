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

enum AddVcLabel {
  static let createNewVector = "Create New Vector:"
  static let startPoint = "Start Point:"
  static let endPoint = "End Point:"
  static let setLength = "Or Just Set The Length of The Vector and Position it Manually:"
  static let addVector = "Add Vector"
  static let manual = " Just in case:\n Origin - left bottom angel of the screen.\n Length value belongs to (0, 2700)\n X and Y belongs to (0, 2700) and (0, 1500) accordingly."
}

enum AlertData {
  static let tooMuch = "Oops... Too Much Data!"
  static let bothCases = "You just entered Data for both Cases of creating Vector. Please, choose One."
  
  static let wrongData = "Oops... Wrang data."
  static let wrongDataBody = "Please, check entered data and try again."
  
  static let wrongLength = "Oops... Wrang length."
  static let wrongLengthBody = "Please, make sure that the length value belongs to (0, 2700)."
  
  static let wrongPoints = "Oops... Wrang points."
  static let wrongPointsBody = "Please, make sure that points values belong to: X(0, 2700), Y(0, 1500)."
}

enum ImageName {
  static let background = "mainSceneBackground2"
  static let vectorHolder = "vectorHolder"
  static let vectorArrow = "arrow"
}

enum Layer {
  static let background: CGFloat = 0
  static let vector: CGFloat = 1
  static let vectorHolder:CGFloat = 2
  static let vectorArrow: CGFloat = 3
  static let actualVector: CGFloat = 4
  static let foreground: CGFloat = 5
}

enum PhysicsCategory {
  static let vectorEnds: UInt32 = 1
}

enum CollectionViewSection {
  case main
}

enum SceneSize {
  static let x: Int = 2700
  static let y: Int = 1500
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

