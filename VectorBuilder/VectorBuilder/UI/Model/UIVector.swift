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
  
  var id: UUID = UUID()
  
  private lazy var vector: SKSpriteNode = {
    let vecSize = CGSize(width: 0.002,
                         height: startPoint.length(toPoint: endPoint) / CGFloat(SceneSize.x))
    let vector = SKSpriteNode(color: color, size: vecSize)
    
    return vector
  }()
  
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
    
    vector.anchorPoint = CGPoint(x: 0.5, y: 0)
    vector.zPosition = Layer.vector
    
    vector.position = CGPoint(x: startPoint.x / CGFloat(SceneSize.x),
                              y: startPoint.y / CGFloat(SceneSize.y))
    vector.zRotation = startPoint.angleWithPoint(endPoint)
    vector.name = SpriteNodeName.vector
    
    addChild(vector)
    
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    vectorHolder.size = CGSize(width:  10 / CGFloat(SceneSize.y),
                               height: 10 / CGFloat(SceneSize.y))
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder
    vectorHolder.name = SpriteNodeName.holder

    vector.addChild(vectorHolder)
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    
    vectorArrow.size = CGSize(width: 7 * 0.001,
                              height: 10 * 0.001)
    vectorArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = CGPoint(x: 0, y: vector.size.height)
    vectorArrow.colorBlendFactor = 1
    vectorArrow.color = color
    vectorArrow.name = SpriteNodeName.arrow

    vector.addChild(vectorArrow)
  }
  
  func highlight() {
    let fadeOut = SKAction.fadeOut(withDuration: 0.1)
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
 
    let increaseSize = SKAction.resize(toWidth: 0.0035, duration: 0.5)
    let wait = SKAction.wait(forDuration: 1)
    let decreaseSize = SKAction.resize(toWidth: 0.002, duration: 0.5)
    let sequenceAction = SKAction.sequence([increaseSize, wait, decreaseSize])
    
    self.vector.run(sequenceAction)
    self.run(fadeSequence)
  }
}
