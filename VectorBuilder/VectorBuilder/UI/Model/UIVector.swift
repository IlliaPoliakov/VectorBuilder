//
//  UIVector.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SpriteKit

final class UIVector: SKNode {
  
  init(startPoint: CGPoint, endPoint: CGPoint, color: UIColor) {
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.color = color
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // -MARK: - Properties -
  
  var startPoint: CGPoint
  var endPoint: CGPoint
  var color: UIColor
  
  private(set) var vector: SKSpriteNode!
  private var arrow: SKSpriteNode!
  private var holder: SKSpriteNode!
  
  lazy var angleSquare: SKSpriteNode = setUpAngleSquare()
  
  var conjugateVectors: [UIVector] = []
  
  var activeNode: SKSpriteNode? = nil
  var isInEditingMode: Bool = false
  
  
  // Model should be as simple and stupid as it can, so I'll fix it soon, but now this methods live her
  
  // -MARK: - SetUp Nodes -
  
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
  
  private func setUpAngleSquare() -> SKSpriteNode {
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
  }
  
  
  // -MARK: - Adjust Vectors Data -
  
  func changeWidth(forState state: Bool) {
    if state {  // true => increase
      let increaseSize = SKAction.resize(toWidth: 0.0055, duration: 0.2)
      self.vector.run(increaseSize)
    }
    else {
      let decreaseSize = SKAction.resize(toWidth: 0.0035, duration: 0.2)
      self.vector.run(decreaseSize)
    }
  }
  
  func pinToVector(_ vector: UIVector, withEndToEndType endToEndType: PinEndToEndType) {
    if isInEditingMode { // not just replace vec, but position its ends relative to another vec ends
      pinToVectorWhenEditingModeOn(vector, withEndToEndType: endToEndType)
    }
    else { // just replace to appropriate point
      var point: CGPoint? = nil
      
      switch endToEndType {
      case .arrowToArrow:
        point = CGPoint(
          x: (vector.endPoint.x - self.endPoint.x + self.startPoint.x) / CGFloat(SceneSize.width),
          y: (vector.endPoint.y - self.endPoint.y + self.startPoint.y) / CGFloat(SceneSize.height))
        
      case .arrowToHolder:
        point = CGPoint(
          x: (vector.startPoint.x - self.endPoint.x + self.startPoint.x) / CGFloat(SceneSize.width),
          y: (vector.startPoint.y - self.endPoint.y + self.startPoint.y) / CGFloat(SceneSize.height))
        
      case .holderToHolder:
        point = CGPoint(
          x: (vector.startPoint.x) / CGFloat(SceneSize.width),
          y: (vector.startPoint.y) / CGFloat(SceneSize.height))
        
      case .holderToArrow:
        point = CGPoint(
          x: (vector.endPoint.x) / CGFloat(SceneSize.width),
          y: (vector.endPoint.y) / CGFloat(SceneSize.height))
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
  
  func handleLongTapEditing(
    forNewPoint point: CGPoint,
    withVectorEnd endNode: VectorEndNode,
    withDuration duration: Double) {
      
      var rotateAction: SKAction? = nil
      var lengthAction: SKAction? = nil
      var moveAction: SKAction? = nil
      
      switch endNode {
      case .arrow:
        let (angle, point) = determineVectorDataForLongTapEditingWithArrow(
          withInitialAngle: startPoint.angleWithPoint(point),
          withNewPoint: point)
        
        rotateAction = SKAction.rotate(
          toAngle: angle,
          duration: duration)
        lengthAction = SKAction.resize(
          toHeight: startPoint.length(toPoint: point) /
          CGFloat(SceneSize.height),
          duration: duration)
        
        self.endPoint = point
        
      case .holder:
        let (angle, point) = determineVectorDataForLongTapEditingWithHolder(
          withInitialAngle: pi + endPoint.angleWithPoint(point),
          withNewPoint: point)
        
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
  
  
  // -MARK: - Helpers -
  
  // magic numbers, but it whould be really messy in another way, I have some questions here
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
  
  private func pinToVectorWhenEditingModeOn(_ vector: UIVector,
                                            withEndToEndType endToEndType: PinEndToEndType) {
    switch endToEndType {
    case .arrowToArrow:
      handleLongTapEditing(
        forNewPoint: vector.endPoint,
        withVectorEnd: .arrow,
        withDuration: 0.2)
      
    case .arrowToHolder:
      handleLongTapEditing(
        forNewPoint: vector.startPoint,
        withVectorEnd: .arrow,
        withDuration: 0.2)
      
    case .holderToArrow:
      handleLongTapEditing(
        forNewPoint: vector.endPoint,
        withVectorEnd: .holder,
        withDuration: 0.2)
      
    case .holderToHolder:
      handleLongTapEditing(
        forNewPoint: vector.startPoint,
        withVectorEnd: .holder,
        withDuration: 0.2)
    }
    
    changeWidth(forState: false)
  }
  
  private func determineVectorDataForLongTapEditingWithArrow(
    withInitialAngle angle: Double,
    withNewPoint point: CGPoint) -> (Double, CGPoint) {
      var resultAngle: Double = angle
      var resultPoint: CGPoint = point
      
      switch angle {  // setUp angle and point relative to origin
      case let angle where angle >= -angleDelta && angle <= angleDelta:
        resultAngle = 0
        resultPoint.x = startPoint.x
        
      case let angle where angle >= pi - angleDelta || angle <= -pi + angleDelta:
        resultAngle = pi
        resultPoint.x = startPoint.x
        
      case let angle where angle >= pi/2 - angleDelta && angle <= pi/2 + angleDelta:
        resultAngle = pi/2
        resultPoint.y = startPoint.y
        
      case let angle where angle >= -pi/2 - angleDelta && angle <= -pi/2 + angleDelta:
        resultAngle = -pi/2
        resultPoint.y = startPoint.y
        
      default:
        break
      }
      
      conjugateVectors.forEach { vector in  // setUp angle and point relative to conjugate vectors
        let angleWithVector = self.vector.zRotation - vector.vector.zRotation
        
        switch angleWithVector {
        case let angle where angle >= -angleDelta && angle <= angleDelta:
          resultAngle = vector.vector.zRotation
          
        case let angle where angle >= pi/2 - angleDelta && angle <= pi/2 + angleDelta:
          resultAngle = vector.vector.zRotation + pi/2
          if self.vector.position == vector.vector.position {
            presentAngleSquare(forAngle: resultAngle)
          }
          else {
            presentAngleSquare(forAngle: pi/2 + resultAngle)
          }
          
        case let angle where angle >= -pi/2 - angleDelta && angle <= -pi/2 + angleDelta:
          resultAngle = vector.vector.zRotation - pi/2
          
          if self.vector.position == vector.vector.position {
            presentAngleSquare(forAngle: pi/2 + resultAngle)
          }
          else {
            presentAngleSquare(forAngle: resultAngle)
          }
          
        case let angle where (angle >= pi - angleDelta && angle <= pi + angleDelta) ||
          (angle >= -pi - angleDelta && angle <= -pi + angleDelta):
          resultAngle = pi + vector.vector.zRotation
          
        default:
          angleSquare.isHidden = true
          break
        }
      }
      
      if angle > resultAngle + angleDelta {
        resultAngle = resultAngle + angleDelta + 0.01
      }
      if angle < resultAngle - angleDelta && angle > -pi + angleDelta {
        resultAngle = resultAngle - angleDelta - 0.01
      }
      
      return (resultAngle, resultPoint)
    }
  
  private func determineVectorDataForLongTapEditingWithHolder( // same as previous
    withInitialAngle angle: Double,
    withNewPoint point: CGPoint) -> (Double, CGPoint) {
      var resultAngle: Double = angle
      var resultPoint: CGPoint = point
      
      switch angle {
      case let angle where angle >= pi - angleDelta && angle <= pi + angleDelta:
        resultAngle = pi
        resultPoint.x = endPoint.x
        
      case let angle where angle >= pi/2 - angleDelta && angle <= pi/2 + angleDelta:
        resultAngle = pi/2
        resultPoint.y = endPoint.y
        
      case let angle where angle >= pi * 2 - angleDelta || angle <= angleDelta:
        resultAngle = 0
        resultPoint.x = endPoint.x
        
      case let angle where angle >= pi * 3/2 - angleDelta && angle <= pi * 3/2 + angleDelta:
        resultAngle = pi * 3/2
        resultPoint.y = endPoint.y
        
      default:
        break
      }
      
      return (resultAngle, resultPoint)
    }
  
  private func presentAngleSquare(forAngle angle: Double) {
    angleSquare.zRotation = angle
    angleSquare.position = self.vector.position
    angleSquare.isHidden = false
  }
}
