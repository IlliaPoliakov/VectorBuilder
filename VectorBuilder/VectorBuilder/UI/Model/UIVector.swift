//
//  UIVector.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit

struct UIVector {
  var startPoint: CGPoint
  var endPoint: CGPoint
  var color: UIColor
  
  init(startPoint: CGPoint, endPoint: CGPoint, color: UIColor) {
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.color = color
  }
}
