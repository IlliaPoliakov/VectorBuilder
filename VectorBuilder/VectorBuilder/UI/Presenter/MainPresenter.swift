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
  func assignViewController(_ viewController: UIViewController)
  func addVectorButtonTupped()
  func unwindFromAddViewController(withNewVector vector: UIVector)
}

final class MainPresenter: SKScene, MainPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: MainViewController?
 
  private let getVectorsUseCase: GetVectorsUseCase =
  AppDelegate.DIContainer.resolve(GetVectorsUseCase.self)!
  
  
  // -MARK: - Properties -
 
  private var vectors = [UIVector]()
 
  private var subscriptions = Set<AnyCancellable>()
  
  // -MARK: - Funcs -
  
  override func didMove(to view: SKView) {
    setUpPhysics()
    setUpBackground()
    initialize()
  }
  
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? MainViewController)
  }
  
  func addVectorButtonTupped() {
    AppDelegate.router.presentAddVectorViewController()
  }
  
  private func setUpPhysics() {
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
  }
  
  private func setUpBackground() {
    let background = SKSpriteNode(imageNamed: ImageName.background)
    background.anchorPoint = CGPoint(x: 0, y: 0)
    background.position = CGPoint(x: 0, y: 0)
    background.zPosition = Layer.background
    background.size = self.size
    
    addChild(background)
  }
  
  func setUpVector(_ vector: UIVector) {
    let startPoint = vector.startPoint
    let endPoint = vector.endPoint
    let color = vector.color
    
    let size = CGSize(width: 0.002, height: startPoint.length(toPoint: endPoint) / self.size.height * 0.001)
    let vector = SKSpriteNode( color: color, size: size)
    
    vector.anchorPoint = CGPoint(x: 0.5, y: 0)
    vector.zPosition = Layer.vector
    vector.position = CGPoint(x: startPoint.x / self.size.width * 0.001,
                              y: startPoint.y / self.size.height * 0.001)
    vector.zRotation = startPoint.angleWithPoint(endPoint)
    
    
    let vectorHolder = SKSpriteNode(imageNamed: ImageName.vectorHolder)
    vectorHolder.size = CGSize(width: self.size.width * 0.008, height: self.size.width * 0.008)
    vectorHolder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorHolder.position = CGPoint(x: 0, y: 0)
    vectorHolder.zPosition = Layer.vectorHolder
    
//    vectorHolder.physicsBody = SKPhysicsBody(circleOfRadius: vectorHolder.size.width)
//    vectorHolder.physicsBody?.isDynamic = true
//    vectorHolder.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
//    vectorHolder.physicsBody?.collisionBitMask = PhysicsCategory.vectorEnds
//
    vector.addChild(vectorHolder)
    
    let vectorArrow = SKSpriteNode(imageNamed: ImageName.vectorArrow)
    vectorArrow.size = CGSize(width: 7 / self.size.width * 0.001,
                              height: 10 / self.size.width * 0.001)
    vectorArrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    vectorArrow.zPosition = Layer.vectorArrow
    vectorArrow.position = CGPoint(x: 0, y: vector.size.height)
    vectorArrow.colorBlendFactor = 1
    vectorArrow.color = color

//    vectorArrow.physicsBody = SKPhysicsBody(circleOfRadius: vectorArrow.size.width)// tmp
//    vectorArrow.physicsBody?.isDynamic = true
//    vectorArrow.physicsBody?.categoryBitMask = PhysicsCategory.vectorEnds
//    vectorArrow.physicsBody?.collisionBitMask = PhysicsCategory.vectorEnds
//    
    vector.addChild(vectorArrow)
    
    self.addChild(vector)
  }
  
  private func initialize() {
    var subscription: AnyCancellable? = nil
    
    subscription = getVectorsUseCase.execute()
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in
        subscription?.cancel()
      }) { vectors in
        self.vectors = vectors
        var lastVector: UIVector?
        
        for vector in vectors {
          self.setUpVector(vector)
          lastVector = vector
        }
        if let lastVector {
          self.moveScrollViewToPoint(CGPoint(x: lastVector.startPoint.x,
                                             y: lastVector.startPoint.y))
        }
      }
  }
  
  func moveScrollViewToPoint(_ point: CGPoint){
    viewController?.scrollView.setContentOffset(CGPoint(x:  point.x, y: point.y), animated: true)
  }
  
  func unwindFromAddViewController(withNewVector vector: UIVector) {
    vectors.append(vector)
    moveScrollViewToPoint(vector.endPoint)
    setUpVector(vector)
  }
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}
