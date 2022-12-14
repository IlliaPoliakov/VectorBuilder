//
//  MainPresenter.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SpriteKit
import Combine

protocol MainPresenterProtocol {
  var vectors: [UIVector] { get set }
  var mainPresenterDelegete: MainPresenterDelegete? { get set }
  
  func assignViewController(_ viewController: UIViewController)
  func onAddVectorButtonTap()
  func onSideBarButtonTap()
  func unwindFromAddViewController(withNewVector vector: UIVector)
  func moveScrollViewToPoint(_ point: CGPoint)
  
  func longTapBegan()
  func longTapMoved(withSender sender: UILongPressGestureRecognizer)
  func longTapEnded(withSender sender: UILongPressGestureRecognizer)
}

protocol MainPresenterDelegete {
  func toggleSideBar()
}

final class MainPresenter: SKScene, MainPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: MainViewController?
  
  var mainPresenterDelegete: MainPresenterDelegete?
  
  private let getVectorsUseCase: GetVectorsUseCase =
  AppDelegate.DIContainer.resolve(GetVectorsUseCase.self)!
  
  private let updateVectorPositionUseCase: UpdateVectorPositionUseCase =
  AppDelegate.DIContainer.resolve(UpdateVectorPositionUseCase.self)!
  
  
  // -MARK: - Properties -
  
  var vectors = [UIVector]()
  
  private lazy var activeVector: UIVector? = nil
  private lazy var touchOffsetX: CGFloat = 0
  private lazy var touchOffsetY: CGFloat = 0
  
  
  // -MARK: - Self Methods -
  
  private func getVectors() {
    var subscription: AnyCancellable? = nil
    
    subscription = getVectorsUseCase.execute()
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
        subscription?.cancel()
      }) { vectors in
        self.vectors = vectors
        var lastVector: UIVector?
        
        vectors.enumerated().forEach { index, vector in
          vector.addToScene(self, withName: String(index))
          lastVector = vector
        }
        
        if let lastVector {
          self.moveScrollViewToPoint(lastVector.endPoint)
        }
      }
  }

  
  // -MARK: - Protocol Methods -
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? MainViewController)
  }
  
  func onAddVectorButtonTap() {
    AppDelegate.router.presentAddVectorViewController()
  }
  
  func onSideBarButtonTap() {
    mainPresenterDelegete?.toggleSideBar()
  }
  
  func unwindFromAddViewController(withNewVector vector: UIVector) {
    vectors.append(vector)
    moveScrollViewToPoint(vector.endPoint)
    vector.addToScene(self, withName: String(vectors.count))
    
    vector.highlight()
  }
  
  func moveScrollViewToPoint(_ point: CGPoint) {
    guard let frame = viewController?.view.frame else { return }
    var safePoint: CGPoint = point
    
    safePoint.x = CGFloat(SceneSize.width / 2) + point.x - frame.width / 2
    safePoint.y = CGFloat(SceneSize.height / 2) - point.y - frame.height / 2
    
    if safePoint.x < 0 {
      safePoint.x = 0
    }
    if safePoint.x > CGFloat(SceneSize.height) - frame.width {
      safePoint.x = CGFloat(SceneSize.height) - frame.width
    }
    if safePoint.y < 0 {
      safePoint.y = 0
    }
    if safePoint.y > CGFloat(SceneSize.height) - frame.height {
      safePoint.y = CGFloat(SceneSize.height) - frame.height
    }
    
    viewController?.scrollView.setContentOffset(
      CGPoint(x: safePoint.x, y: safePoint.y),
      animated: true)
  }
  
  
  // -MARK: - SKScene Methods -
  
  override func didMove(to view: SKView) {
    setUpPhysics()
    setUpBackground()
    getVectors()
  }
  
  private func setUpPhysics() {
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
  
  private func setUpBackground() {
    let background = SKSpriteNode(imageNamed: ImageName.background)
    background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    background.position = CGPoint(x: 0, y: 0)
    background.zPosition = Layer.background
    background.size = self.size
    background.name = SpriteNodeName.background
    
    addChild(background)
  }
  
  
  // -MARK: - Short tap Handalling -
  
  // all sprites have names like "name3", it means that all names are unique, but
  // also I can check for prefix and determine type of touched sprite
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchPoint = touch.location(in: self)
      let touchedNode = atPoint(touchPoint)
      
      guard let touchedNodeName = touchedNode.name else { return }
      
      switch touchedNodeName {
      case let name where name.hasPrefix(SpriteNodeName.vector):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode.parent as? UIVector
        
        touchOffsetX = touchPoint.x - touchedNode.position.x
        touchOffsetY = touchPoint.y - touchedNode.position.y
        
      case let name where name.hasPrefix(SpriteNodeName.holder):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode.parent?.parent as? UIVector
        touchOffsetX = 0
        touchOffsetY = 0
        
      case let name where name.hasPrefix(SpriteNodeName.arrow):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode.parent?.parent as? UIVector
        
        guard let activeVector
        else { return }
        
        touchOffsetX = (activeVector.endPoint.x - activeVector.startPoint.x) /
        CGFloat(SceneSize.width)
        touchOffsetY = (activeVector.endPoint.y - activeVector.startPoint.y) /
        CGFloat( SceneSize.height)
        
      default:
        break
      }
      
      activeVector?.activeNode = touchedNode as? SKSpriteNode
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let activeVector,
       let touchPosition = touches.first?.location(in: self) {
      
      activeVector.vector.position = CGPoint(x: touchPosition.x - touchOffsetX,
                                             y: touchPosition.y - touchOffsetY)
      
      // if vector was pinned, clean relation ships after drag
      activeVector.conjugateVectors.forEach { vector in
        vector.conjugateVectors.removeAll(where: { $0 == activeVector })
      }
      activeVector.conjugateVectors.removeAll()
      activeVector.angleSquare.isHidden = true
    }
  }
  
  // save new vec start/end points
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let activeVector else { return }
    
    let newStartPoint = CGPoint(
      x: activeVector.vector.position.x * CGFloat(SceneSize.height),
      y: activeVector.vector.position.y * CGFloat(SceneSize.height))
    let newEndPoint = CGPoint(
      x: newStartPoint.x + activeVector.endPoint.x - activeVector.startPoint.x,
      y: newStartPoint.y + activeVector.endPoint.y - activeVector.startPoint.y)
    
    updateVectorPositionUseCase.execute(
      withVector: activeVector,
      withStartPoint: newStartPoint,
      withEndPoint: newEndPoint)
    
    activeVector.startPoint = newStartPoint
    activeVector.endPoint = newEndPoint
    activeVector.activeNode = nil
    
    self.activeVector = nil
    
    viewController?.scrollView.isScrollEnabled = true
  }
  
  
  // -MARK: - Long tap Handalling -
  
  func longTapBegan() {
    guard let isVector = activeVector?.activeNode?.name?.hasPrefix(SpriteNodeName.vector),
          !isVector
    else { return }
    
    activeVector?.isInEditingMode = true
    
    activeVector?.changeWidth(forState: true)
  }
  
  func longTapMoved(withSender sender: UILongPressGestureRecognizer) {
    guard let name = activeVector?.activeNode?.name,
          let activeVector
    else { return }
    
    switch name {
    case let name where name.hasPrefix(SpriteNodeName.arrow):
      var newPoint = sender.location(in: viewController?.scrollView)
      newPoint = CGPoint(x: newPoint.x - CGFloat(SceneSize.width / 2),
                         y: CGFloat(SceneSize.height) / 2 - newPoint.y)
      
      activeVector.handleLongTapEditing(
        forNewPoint: newPoint,
        withVectorEnd: .arrow,
        withDuration: 0)
      
    case let name where name.hasPrefix(SpriteNodeName.holder):
      var newPoint = sender.location(in: viewController?.scrollView)
      newPoint = CGPoint(x: newPoint.x - CGFloat(SceneSize.width / 2),
                         y: CGFloat(SceneSize.height) / 2 - newPoint.y )
      
      activeVector.handleLongTapEditing(
        forNewPoint: newPoint,
        withVectorEnd: .holder,
        withDuration: 0)
      
    default:
      break
    }
  }
  
  func longTapEnded(withSender sender: UILongPressGestureRecognizer) {
    
    activeVector?.changeWidth(forState: false)
    
    var point = sender.location(in: viewController?.scrollView)
    point = CGPoint(x: point.x - CGFloat(SceneSize.width / 2),
                    y: CGFloat(SceneSize.height) / 2 - point.y )
    
    guard let activeVector,
          let name = activeVector.activeNode?.name
    else { return }
    
    switch name {
    case let name where name.hasPrefix(SpriteNodeName.arrow):
      updateVectorPositionUseCase.execute(
        withVector: activeVector,
        withStartPoint: activeVector.startPoint,
        withEndPoint: point)
      
    case let name where name.hasPrefix(SpriteNodeName.holder):
      updateVectorPositionUseCase.execute(
        withVector: activeVector,
        withStartPoint: point,
        withEndPoint: activeVector.endPoint)
      
    default:
      break
    }
    
    activeVector.activeNode = nil
    activeVector.isInEditingMode = false
    
    self.activeVector = nil
    
    viewController?.scrollView.isScrollEnabled = true
  }
}


// -MARK: - Collision Handalling -

extension MainPresenter: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    guard let firstNode: UIVector = contact.bodyA.node?.parent?.parent as? UIVector,
          let secondNode: UIVector = contact.bodyB.node?.parent?.parent as? UIVector,
          firstNode != secondNode,
          !firstNode.conjugateVectors.contains(secondNode)
    else { return }
    
    let firstNodeStartPointForSave = firstNode.startPoint
    let firstNodeEndPointForSave = firstNode.endPoint
    let secondNodeStartPointForSave = secondNode.startPoint
    let secondNodeEndPointForSave = secondNode.endPoint
    
    firstNode.conjugateVectors.append(secondNode)
    secondNode.conjugateVectors.append(firstNode)

    guard let firstEndName = contact.bodyA.node?.name,
          let secondEndName = contact.bodyB.node?.name
    else { return }
    
    if firstNode.activeNode != nil {
      if firstEndName.hasPrefix(SpriteNodeName.arrow) {
        if secondEndName.hasPrefix(SpriteNodeName.arrow) {
          firstNode.pinToVector(
            secondNode,
            withEndToEndType: .arrowToArrow)
        }
        else {
          firstNode.pinToVector(
            secondNode,
            withEndToEndType: .arrowToHolder)
        }
      }
      else {
        if secondEndName.hasPrefix(SpriteNodeName.arrow) {
          firstNode.pinToVector(
            secondNode,
            withEndToEndType:  .holderToArrow)
        }
        else {
          firstNode.pinToVector(
            secondNode,
            withEndToEndType: .holderToHolder)
        }
      }
    }
    else {
      if secondEndName.hasPrefix(SpriteNodeName.arrow) {
        if firstEndName.hasPrefix(SpriteNodeName.arrow) {
          secondNode.pinToVector(
            firstNode,
            withEndToEndType: .arrowToArrow)
        }
        else {
          secondNode.pinToVector(
            firstNode,
            withEndToEndType: .arrowToHolder)
        }
      }
      else {
        if firstEndName.hasPrefix(SpriteNodeName.arrow) {
          secondNode.pinToVector(
            firstNode,
            withEndToEndType: .holderToArrow)
        }
        else {
          secondNode.pinToVector(
            firstNode,
            withEndToEndType: .holderToHolder)
        }
      }
    }
    
    updateVectorPositionUseCase.execute(
      withVector: UIVector(startPoint: firstNodeStartPointForSave,
                           endPoint: firstNodeEndPointForSave,
                           color: firstNode.color),
      withStartPoint: firstNode.startPoint,
      withEndPoint: firstNode.endPoint)
    
    updateVectorPositionUseCase.execute(
      withVector: UIVector(startPoint: secondNodeStartPointForSave,
                           endPoint: secondNodeEndPointForSave,
                           color: secondNode.color),
      withStartPoint: secondNode.startPoint,
      withEndPoint: secondNode.endPoint)
    
    activeVector?.activeNode = nil
    activeVector = nil
  }
}
