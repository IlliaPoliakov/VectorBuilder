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
  
  var conjugateVectors: [UIVector] = []
  
  var activeNode: SKSpriteNode? = nil
  var isInEditingMode: Bool = false
  
  lazy var squareAngle: SKSpriteNode = {
    let square = SKSpriteNode(imageNamed: ImageName.square)
    square.size = CGSize(
      width:  17 / CGFloat(SceneSize.height),
      height: 17 / CGFloat(SceneSize.width))
    square.color = .gray
    square.colorBlendFactor = 1
    square.anchorPoint = CGPoint(x: 0, y: 0)
    square.zPosition = Layer.angleSquare
    square.position = self.vector.position
    square.zRotation = self.vector.zRotation
    square.isHidden = true
    
    addChild(square)
    
    return square
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
  
  func addToScene(_ scene: SKScene, withName name: String) {
    self.zPosition = Layer.vector
    scene.addChild(self)
    
    let vector = setUpVector(withName: name)
    addChild(vector)
    
    let vectorHolder = setUpVectorHolder(withName: name)
    vector.addChild(vectorHolder)
    
    let vectorArrow = setUpVectorArrow(withName: name)
    vector.addChild(vectorArrow)
  }
  
  private func setUpVectorArrow(withName name: String) -> SKSpriteNode {
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
    
    vectorArrow.physicsBody = SKPhysicsBody(circleOfRadius: holder.size.width * 4)
    vectorArrow.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorArrow.physicsBody?.contactTestBitMask = PhysicsCategory.vectorEnds
    
    return vectorArrow
  }
  
  private func setUpVector(withName name: String) -> SKSpriteNode {
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
    
    return vector
  }
  
  private func setUpVectorHolder(withName name: String) -> SKSpriteNode {
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    self.holder = vectorHolder
    
    vectorHolder.size = CGSize(
      width:  13 / CGFloat(SceneSize.height),
      height: 13 / CGFloat(SceneSize.width))
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder
    vectorHolder.name = SpriteNodeName.holder + name
    
    vectorHolder.physicsBody = SKPhysicsBody(circleOfRadius: vectorHolder.size.width * 4)
    vectorHolder.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
    vectorHolder.physicsBody?.contactTestBitMask = PhysicsCategory.vectorEnds
    
    return vectorHolder
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
      
      changeWidthForState(changingState: false)
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
      let (angle, point) = determineAngleandPointForArrow(
        withInitialAngle: startPoint.angleWithPoint(point),
        withPoint: point)
      
      rotateAction = SKAction.rotate(
        toAngle: angle,
        duration: duration)
      lengthAction = SKAction.resize(
        toHeight: startPoint.length(toPoint: point) /
        CGFloat(SceneSize.height),
        duration: duration)
      
      self.endPoint = point
      
    case .holder:
      let (angle, point) = determineAngleandPointForArrow(
        withInitialAngle: 3.14 + endPoint.angleWithPoint(point),
        withPoint: point)
      
      rotateAction = SKAction.rotate(
        toAngle: angle,
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
  
  private func determineAngleandPointForHolder(
    withInitialAngle angle: Double,
    withPoint point: CGPoint) -> (Double, CGPoint) {
      var resultAngle: Double = angle
      var resultPoint: CGPoint = point
      
//      switch angle {
//      case let angle where angle >= -0.07 && angle <= 0.07:
//        resultAngle = 0
//        resultPoint.x = endPoint.x
//        
//      case let angle where angle >= 3.07 || angle <= -3.07:
//        resultAngle = 3.14
//        resultPoint.x = endPoint.x
//        
//      case let angle where angle >= 1.5 && angle <= 1.65:
//        resultAngle = 1.57
//        resultPoint.y = endPoint.y
//        
//      case let angle where angle >= -1.65 && angle <= -1.5:
//        resultAngle = -1.57
//        resultPoint.y = endPoint.y
//        
//      default:
//        break
//      }
      
//      conjugateVectors.forEach { vector in
//        let angleWithVector = self.vector.zRotation - vector.vector.zRotation
//
//        switch angleWithVector {
//        case let angle where angle >= -0.07 && angle <= 0.07:
//          resultAngle = vector.vector.zRotation
//
//        case let angle where angle >= 1.5 && angle <= 1.64:
//          resultAngle = vector.vector.zRotation + 1.57
//          presentAngleSquare(forAngle: 1.57 + resultAngle)
//
//        case let angle where angle >= -1.64 && angle <= -1.5:
//          resultAngle = vector.vector.zRotation - 1.57
//          presentAngleSquare(forAngle: resultAngle)
//
//        default:
//          squareAngle.isHidden = true
//          break
//        }
//      }
      
      if angle > resultAngle + 0.07 {
        resultAngle += 0.08
      }
      if angle < resultAngle - 0.07 {
        if angle > -3.07 {
          resultAngle -= 0.08
        }
      }
      
      return (resultAngle, resultPoint)
    }
  
  private func determineAngleandPointForArrow(
    withInitialAngle angle: Double,
    withPoint point: CGPoint) -> (Double, CGPoint) {
      var resultAngle: Double = angle
      var resultPoint: CGPoint = point
      
      switch angle {
      case let angle where angle >= -0.07 && angle <= 0.07:
        resultAngle = 0
        resultPoint.x = startPoint.x
        
      case let angle where angle >= 3.07 || angle <= -3.07:
        resultAngle = 3.14
        resultPoint.x = startPoint.x
        
      case let angle where angle >= 1.5 && angle <= 1.65:
        resultAngle = 1.57
        resultPoint.y = startPoint.y
        
      case let angle where angle >= -1.65 && angle <= -1.5:
        resultAngle = -1.57
        resultPoint.y = startPoint.y
        
      default:
        break
      }
      
      conjugateVectors.forEach { vector in
        let angleWithVector = self.vector.zRotation - vector.vector.zRotation
        
        switch angleWithVector {
        case let angle where angle >= -0.07 && angle <= 0.07:
          resultAngle = vector.vector.zRotation
          
        case let angle where angle >= 1.5 && angle <= 1.64:
          resultAngle = vector.vector.zRotation + 1.57
          presentAngleSquare(forAngle: 1.57 + resultAngle)
          
        case let angle where angle >= -1.64 && angle <= -1.5:
          resultAngle = vector.vector.zRotation - 1.57
          presentAngleSquare(forAngle: resultAngle)
          
        default:
          squareAngle.isHidden = true
          break
        }
      }
      
      if angle > resultAngle + 0.07 {
        resultAngle += 0.08
      }
      if angle < resultAngle - 0.07 {
        if angle > -3.07 {
          resultAngle -= 0.08
        }
      }
      
      return (resultAngle, resultPoint)
    }
  
  private func presentAngleSquare(forAngle angle: Double) {
    squareAngle.zRotation = angle
    squareAngle.position = self.vector.position
    squareAngle.isHidden = false
  }
}
