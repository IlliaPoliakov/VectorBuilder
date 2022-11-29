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
    self.color = .red
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addToScene(_ scene: SKScene) {
    self.zPosition = Layer.vector
    scene.addChild(self)
    
    let vector = SKSpriteNode(color: color, size: CGSize(width: 5, height: 50))
    vector.anchorPoint = CGPoint(x: 0, y: 0)
    vector.zPosition = Layer.vector
    vector.position = startPoint.centerPoint(withPoint: endPoint)
    vector.zRotation = startPoint.angleWithPoint(endPoint)
    
    self.addChild(vector)
    
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    vectorHolder.anchorPoint = CGPoint(x: 0, y: 0)
    vectorHolder.position = startPoint
    vectorHolder.zPosition = Layer.vectorHolder
    
    vectorHolder.physicsBody = SKPhysicsBody(circleOfRadius: vectorHolder.size.width)// tmp
    vectorHolder.physicsBody?.isDynamic = true
    vectorHolder.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorHolder.physicsBody?.collisionBitMask = PhysicsCategory.vectorEnds
    
    vector.addChild(vectorHolder)
    
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    vectorArrow.anchorPoint = CGPoint(x: 0, y: 0)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = endPoint
    vectorArrow.color = color
    vectorArrow.zRotation = startPoint.angleWithPoint(startPoint)
    
    vectorArrow.physicsBody = SKPhysicsBody(circleOfRadius: vectorArrow.size.width)// tmp
    vectorArrow.physicsBody?.isDynamic = true
    vectorArrow.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorArrow.physicsBody?.collisionBitMask = PhysicsCategory.vectorEnds
    
    vector.addChild(vectorArrow)
  }
}
