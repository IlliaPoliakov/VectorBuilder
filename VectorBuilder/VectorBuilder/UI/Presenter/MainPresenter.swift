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
          vector.addToScene(self)
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
    vector.addToScene(self)
  }
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}
