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

enum SideBarCellData {
  static let startPonint = "Start:"
  static let endPonint = "End:"
  static let x = "x: "
  static let y = "y: "
}

enum AddVcLabelData {
  static let createNewVector = "Create New Vector:"
  static let startPoint = "Start Point:"
  static let endPoint = "End Point:"
  static let setLength = "Or Just Set The Length of The Vector:"
  static let addVector = "Add Vector"
  static let manual = """
Just in case:\n Origin - center of the screen.
 Length value belongs to (0,1000).
 X and Y belong to (-500,500).
"""
}

enum AlertData {
  static let tooMuch = "Oops... Too Much Data!"
  static let bothCases = "You just entered Data for both Cases of creating Vector. Please, choose One."
  
  static let wrongData = "Oops... Wrang data."
  static let wrongDataBody = "Please, check entered data and try again."
  
  static let wrongLength = "Oops... Wrang length."
  static let wrongLengthBody = "Please, make sure that the length value belongs to (0, 1000)."
  
  static let wrongPoints = "Oops... Wrang points."
  static let wrongPointsBody = "Please, make sure that points values belong to (-500,500)."
}

enum ImageName {
  static let background = "background"
  static let vectorHolder = "vectorHolder"
  static let vectorArrow = "arrow"
  static let square = "square"
  static let dollarSquare = "dollarSquare"
}

enum Layer {
  static let background: CGFloat = 0
  static let angleSquare: CGFloat = 1
  static let vector: CGFloat = 2
  static let vectorHolder:CGFloat = 3
  static let vectorArrow: CGFloat = 4
  static let actualVector: CGFloat = 5
  static let foreground: CGFloat = 6
}

enum PhysicsCategory {
  static let vectorEnds: UInt32 = 1
}

enum CollectionViewSection {
  case main
}

enum SceneSize {
  static let width: Int = 1000
  static let height: Int = 1000
}

enum ViewData {
  static let borderWidth: CGFloat = 2.5
  static let borderColor: UIColor = Colors.mainColorClear
  static let cornerRadius: CGFloat = 10
}

enum Colors {
  static let mainColorClear: UIColor = UIColor(named: "mainColor")!
  static let mainColorBackground: UIColor = UIColor(named: "mainColor")!
    .withAlphaComponent(0.2)
  static let viewBackgroundColor: UIColor = UIColor(named: "mainColor")!
    .withAlphaComponent(0.4)
}

enum SpriteNodeName {
  static let background = "background"
  static let arrow = "arrow"
  static let holder = "holder"
  static let vector = "vector"
}

enum VectorEndNode {
  case arrow
  case holder
}

enum PinEndToEndType {
  case arrowToArrow
  case arrowToHolder
  case holderToHolder
  case holderToArrow
}

let angleDelta: Double = 0.07
