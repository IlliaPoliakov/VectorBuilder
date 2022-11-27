//
//  Vector.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//

import UIKit

struct Vector {
  var startPoint: CGPoint
  var endPoint: CGPoint
  var colorHex: String
  
  init(startPoint: CGPoint, endPoint: CGPoint, colorHex: String) {
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.colorHex = colorHex
  }
  
  static func convertToUI(withModels models: [Vector]) -> [UIVector] {

    return models.map { model in
      UIVector(startPoint: model.startPoint,
               endPoint: model.endPoint,
               color: UIColor(hex: model.colorHex))
    }
  }
  
  static func convertToModel(withUIVectors UIVectors: [UIVector]) -> [Vector] {

    return UIVectors.map { UIVector in
      Vector(startPoint: UIVector.startPoint,
               endPoint: UIVector.endPoint,
             colorHex: UIVector.color.toHex)
    }
  }
}
