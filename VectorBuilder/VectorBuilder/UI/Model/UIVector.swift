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
  private var arrow: SKSpriteNode!
  private var holder: SKSpriteNode!

  var activeNode: SKSpriteNode? = nil
  var isInEditingMode: Bool = false
  
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
    self.holder = vectorHolder
    
    vectorHolder.size = CGSize(
      width:  13 / CGFloat(SceneSize.height),
      height: 13 / CGFloat(SceneSize.width))
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder
    vectorHolder.name = SpriteNodeName.holder + name
    
    vector.addChild(vectorHolder)
    
    vectorHolder.physicsBody = SKPhysicsBody(circleOfRadius: vectorHolder.size.width * 4)
    vectorHolder.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorHolder.physicsBody?.contactTestBitMask = PhysicsCategory.vectorEnds
    
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    self.arrow = vectorArrow
    
    vectorArrow.size = CGSize(width: 11 / CGFloat(SceneSize.height),
                              height: 14 / CGFloat(SceneSize.height))
    vectorArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = CGPoint(x: 0, y: vector.size.height)
    vectorArrow.colorBlendFactor = 1
    vectorArrow.color = color
    vectorArrow.name = SpriteNodeName.arrow + name

    vector.addChild(vectorArrow)
    
    vectorArrow.physicsBody = SKPhysicsBody(circleOfRadius: vectorHolder.size.width * 4)
    vectorArrow.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorArrow.physicsBody?.contactTestBitMask = PhysicsCategory.vectorEnds
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
  
  func changeWidthForState(changingState state: Bool) {
    if state {
      let increaseSize = SKAction.resize(toWidth: 0.0055, duration: 0.2)
      self.vector.run(increaseSize)
    }
    else {
      let decreaseSize = SKAction.resize(toWidth: 0.0035, duration: 0.2)
      self.vector.run(decreaseSize)
    }
  }
  
  func pinToVector(_ vector: UIVector, withEndToEndType endToEndType: PinEndToEndType) {
    if isInEditingMode {
      switch endToEndType {
      case .arrowToArrow:
        updateDataForNewPoint(
          vector.endPoint,
          withVectorEnd: .arrow,
          withDuration: 0.2)
        
      case .arrowToHolder:
        updateDataForNewPoint(
          vector.startPoint,
          withVectorEnd: .arrow,
          withDuration: 0.2)
        
      case .holderToArrow:
        updateDataForNewPoint(
          vector.endPoint,
          withVectorEnd: .holder,
          withDuration: 0.2)
        
      case .holderToHolder:
        updateDataForNewPoint(
          vector.startPoint,
          withVectorEnd: .holder,
          withDuration: 0.2)
      }
    }
    else {
      var point: CGPoint? = nil
      
      switch endToEndType {
      case .arrowToArrow:
        point = CGPoint(
          x: (vector.endPoint.x - self.endPoint.x + self.startPoint.x) /
          CGFloat(SceneSize.width),
          y: (vector.endPoint.y - self.endPoint.y + self.startPoint.y) /
          CGFloat(SceneSize.height))
        
      case .arrowToHolder:
        point = CGPoint(
          x: (vector.startPoint.x - self.endPoint.x + self.startPoint.x) /
          CGFloat(SceneSize.width),
          y: (vector.startPoint.y - self.endPoint.y + self.startPoint.y) /
          CGFloat(SceneSize.height))
        
      case .holderToHolder:
        point = CGPoint(
          x: (vector.startPoint.x) /
          CGFloat(SceneSize.width),
          y: (vector.startPoint.y) /
          CGFloat(SceneSize.height))
        
      case .holderToArrow:
        point = CGPoint(
          x: (vector.endPoint.x) /
          CGFloat(SceneSize.width),
          y: (vector.endPoint.y) /
          CGFloat(SceneSize.height))
      }
      
      guard let point else { return }
      
      let moveAction = SKAction.move(to: point, duration: 0.2)
      self.vector.run(moveAction)
      
      let actualPoint = CGPoint(x: point.x * CGFloat(SceneSize.width),
                                y: point.y * CGFloat(SceneSize.height))
      self.endPoint = actualPoint + endPoint - startPoint
      self.startPoint = actualPoint
    }
  }
  
  func updateDataForNewPoint(_ point: CGPoint,
                             withVectorEnd endNode: VectorEndNode,
                             withDuration duration: Double) {
    var rotateAction: SKAction? = nil
    var lengthAction: SKAction? = nil
    var moveAction: SKAction? = nil
    
    switch endNode {
    case .arrow:
      rotateAction = SKAction.rotate(
        toAngle: startPoint.angleWithPoint(point),
        duration: duration)
      lengthAction = SKAction.resize(
        toHeight: startPoint.length(toPoint: point) /
        CGFloat(SceneSize.height),
        duration: duration)
      
      self.endPoint = point
      
    case .holder:
      rotateAction = SKAction.rotate(
        toAngle: 3.14 + endPoint.angleWithPoint(point),
        duration: duration)
      lengthAction = SKAction.resize(
        toHeight: point.length(toPoint: endPoint) /
        CGFloat(SceneSize.height),
        duration: duration)
      moveAction = SKAction.move(
        to: CGPoint(x: point.x / CGFloat(SceneSize.height),
                    y: point.y / CGFloat(SceneSize.width)),
        duration: duration)
      
      self.startPoint = point
      
    }
    
    if let rotateAction, let lengthAction {
      self.vector.run(rotateAction)
      self.vector.run(lengthAction) {
        self.arrow.position = CGPoint(x: 0, y: self.vector.size.height)
      }

    }
    
    if let moveAction {
      self.vector.run(moveAction)
    }
  }
}
