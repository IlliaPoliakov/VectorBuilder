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
  
  private lazy var activeVector: SKNode? = nil
  private lazy var touchOffsetX: CGFloat = 0
  private lazy var touchOffsetY: CGFloat = 0
  

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
    background.name = SpriteNodeName.background
    
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
    
    vector.highlight()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchPoint = touch.location(in: self)
      let touchedNode = atPoint(touchPoint)
      
      print(touchedNode.name)
      switch touchedNode.name {
      case SpriteNodeName.vector:
        viewController?.scrollView.isScrollEnabled = false

        activeVector = touchedNode
        touchOffsetX = touchPoint.x - touchedNode.position.x
        touchOffsetY = touchPoint.y - touchedNode.position.y
        
      default:
        break
      }
      
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let activeVector, var touchPosition = touches.first?.location(in: self) {
      activeVector.position = CGPoint(x: touchPosition.x - touchOffsetX,
                                      y: touchPosition.y - touchOffsetY)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if activeVector != nil {
      
      activeVector = nil
      viewController?.scrollView.isScrollEnabled = true
    }
  }
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}
