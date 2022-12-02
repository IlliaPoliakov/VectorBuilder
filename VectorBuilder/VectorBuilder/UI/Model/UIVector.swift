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
  
  private(set) var vector: SKSpriteNode!
  
  init(startPoint: CGPoint, endPoint: CGPoint, color: UIColor) {
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.color = color
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addToScene(_ scene: SKScene, withName name: String) {
    self.zPosition = Layer.vector
    scene.addChild(self)
    
    let vectorSize = CGSize(
      width: 0.0035,
      height: startPoint.length(toPoint: endPoint) / CGFloat(SceneSize.height))
    
    let vector = SKSpriteNode(color: color, size: vectorSize)
    self.vector = vector
    
    vector.anchorPoint = CGPoint(x: 0.5, y: 0)
    vector.zPosition = Layer.vector
    vector.position = CGPoint(
      x: startPoint.x / CGFloat(SceneSize.height),
      y: startPoint.y / CGFloat(SceneSize.width))
    vector.zRotation = startPoint.angleWithPoint(endPoint)
    vector.name = SpriteNodeName.vector + name

    addChild(vector)
    
    
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    vectorHolder.size = CGSize(
      width:  13 / CGFloat(SceneSize.height),
      height: 13 / CGFloat(SceneSize.width))
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder
    vectorHolder.name = SpriteNodeName.holder + name

    vector.addChild(vectorHolder)
    
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    vectorArrow.size = CGSize(width: 11 / CGFloat(SceneSize.height),
                              height: 14 / CGFloat(SceneSize.height))
    vectorArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = CGPoint(x: 0, y: vector.size.height)
    vectorArrow.colorBlendFactor = 1
    vectorArrow.color = color
    vectorArrow.name = SpriteNodeName.arrow + name

    vector.addChild(vectorArrow)
  }
  
  func highlight() {
    let fadeOut = SKAction.fadeOut(withDuration: 0)
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
 
    let increaseSize = SKAction.resize(toWidth: 0.0055, duration: 0.5)
    let wait = SKAction.wait(forDuration: 0.5)
    let decreaseSize = SKAction.resize(toWidth: 0.0035, duration: 0.5)
    let sequenceAction = SKAction.sequence([increaseSize, wait, decreaseSize])
    
    self.vector.run(sequenceAction)
    self.run(fadeSequence)
  }
}
