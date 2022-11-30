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
  func addVectorButtonTupped()
  func sideBarButtonTupped()
  func unwindFromAddViewController(withNewVector vector: UIVector)
  func moveScrollViewToPoint(_ point: CGPoint)
  func highlightVector(_ vector: UIVector)
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
  
  
  // -MARK: - Properties -
 
  var vectors = [UIVector]()
 
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
  
  func sideBarButtonTupped() {
    mainPresenterDelegete?.toggleSideBar()
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
          self.moveScrollViewToPoint(lastVector.endPoint)
        }
      }
  }
  
  func moveScrollViewToPoint(_ point: CGPoint) {
    let frame = viewController!.scrollView.frame
    var safePoint = point
    
    safePoint.y = CGFloat(SceneSize.y) - safePoint.y - frame.height / 2
    safePoint.x -= frame.width / 2
    
    if safePoint.x < 0 {
      safePoint.x = 0
    }
    if safePoint.x > CGFloat(SceneSize.x) - frame.width {
      safePoint.x = CGFloat(SceneSize.x) - frame.width
    }
    if safePoint.y < 0 {
      safePoint.y = 0
    }
    if safePoint.y > CGFloat(SceneSize.y) - frame.height {
      safePoint.x = CGFloat(SceneSize.y) - frame.height
    }
    
    viewController?.scrollView.setContentOffset(
      CGPoint(x: safePoint.x, y: safePoint.y),
      animated: true)
  }
  
  func unwindFromAddViewController(withNewVector vector: UIVector) {
    vectors.append(vector)
    moveScrollViewToPoint(vector.endPoint)
    vector.addToScene(self)
    highlightVector(vector)
  }
  
  func highlightVector(_ vector: UIVector) {
    vector.highlight()
  }
  
  
  var vectorTouchedBool = false
  var touchedVector: UIVector? = nil
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.location(in: self)
    
    let vectors = vectors.filter { $0.contains(touchLocation) }
    guard !vectors.isEmpty
    else {
      return
    }
    vectorTouchedBool = true
    touchedVector = vectors.first
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard vectorTouchedBool,
          let touchedVector
    else {
      return
    }
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.location(in: self)
    touchedVector.position = touchLocation
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    vectorTouchedBool = false
    touchedVector = nil
  }
  
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}
