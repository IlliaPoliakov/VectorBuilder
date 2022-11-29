//
//  UIVector.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SpriteKit

final class UIVector: SKNode {
  var startPoint: CGPoint
  var endPoint: CGPoint
  var color: UIColor
  
  init(startPoint: CGPoint, endPoint: CGPoint, color: UIColor) {
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.color = color
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addToScene(_ scene: SKScene) {
    self.zPosition = Layer.vector
    scene.addChild(self)
    
    let vecSize = CGSize(width: 0.002,
                         height: startPoint.length(toPoint: endPoint)  * 0.001)
    let vector = SKSpriteNode(color: color, size: vecSize)
    vector.anchorPoint = CGPoint(x: 0.5, y: 0)
    vector.zPosition = Layer.vector
    
    vector.position = CGPoint(x: startPoint.x / CGFloat(SceneSize.x),
                              y: startPoint.y / CGFloat(SceneSize.y))
    vector.zRotation = startPoint.angleWithPoint(endPoint)
    
    addChild(vector)
    
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    vectorHolder.size = CGSize(width:  0.008, height: 0.008)
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder

    vector.addChild(vectorHolder)
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    
    vectorArrow.size = CGSize(width: 7 * 0.001,
                              height: 10 * 0.001)
    vectorArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = CGPoint(x: 0, y: vector.size.height)
    vectorArrow.colorBlendFactor = 1
    vectorArrow.color = color

    vector.addChild(vectorArrow)
  }
}
