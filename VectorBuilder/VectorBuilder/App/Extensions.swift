//
//  Extensions.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//

import UIKit

extension UIColor {
  
   convenience init(hex: String) {
    var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    let length = hexNormalized.count
    
    Scanner(string: hexNormalized).scanHexInt64(&rgb)
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      
    }
    else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
      
    }
//    else {
//      return nil
//    }
    
    self.init(red: r, green: g, blue: b, alpha: a)
  }
  
  var toHex: String {
    if let components = cgColor.components,
       components.count >= 3 {
      
      let r = Float(components[0])
      let g = Float(components[1])
      let b = Float(components[2])
      var a = Float(1.0)
      
      if components.count >= 4 {
        a = Float(components[3])
      }
      
      let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255),
                       lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
      
      return hex
    }
    
    return String()
  }
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func distance() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func length(toPoint point: CGPoint) -> CGFloat {
    return sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y))
  }
  
  func centerPoint(withPoint point: CGPoint) -> CGPoint {
    return CGPoint(x: (x + point.x)/2, y: (y + point.y)/2)
  }
  
  func normalized() -> CGPoint {
    return self / distance()
  }
  
  func angleWithPoint(_ point: CGPoint) -> CGFloat {
    let offset = self - point

    let distX = CGFloat(offset.x)
    let distY = CGFloat(offset.y)
    
    let vec = CGVector(dx: distX, dy: distY)

    let angle = atan2(vec.dx, -vec.dy)

//    let deg = angle * CGFloat(180.0 / .pi)
    
    return angle
  }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
