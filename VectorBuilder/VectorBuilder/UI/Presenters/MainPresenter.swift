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
  
  private let updateVectorPositionUseCase: UpdateVectorPositionUseCase =
  AppDelegate.DIContainer.resolve(UpdateVectorPositionUseCase.self)!
  
  
  // -MARK: - Properties -
 
  var vectors = [UIVector]()
  
  private lazy var activeVector: SKNode? = nil
  private lazy var activeEndNode: SKNode? = nil
  private lazy var touchOffsetX: CGFloat = 0
  private lazy var touchOffsetY: CGFloat = 0
  

  // -MARK: - Funcs -
  
  override func didMove(to view: SKView) {
    setUpPhysics()
    setUpBackground()
    getVectors()
    addGestureRecognizer()
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
  
  private func addGestureRecognizer() {
    let pressed:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
    pressed.delegate = self
    pressed.minimumPressDuration = 1.5
    view?.addGestureRecognizer(pressed)
  }
  
  func moveScrollViewToPoint(_ point: CGPoint) {
    guard let frame = viewController?.view.frame else { return }
    var safePoint = point
    
    safePoint.x = safePoint.x + CGFloat(SceneSize.width / 2) - frame.width / 2
    safePoint.y = CGFloat(SceneSize.height / 2) - safePoint.y - frame.height / 2
    
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
      safePoint.x = CGFloat(SceneSize.height) - frame.height
    }
    
    viewController?.scrollView.setContentOffset(
      CGPoint(x: safePoint.x, y: safePoint.y),
      animated: true)
  }
  
  func unwindFromAddViewController(withNewVector vector: UIVector) {
    vectors.append(vector)
    moveScrollViewToPoint(vector.endPoint)
    vector.addToScene(self, withName: String(vectors.count))
    
    vector.highlight()
  }
  
  private func saveVectorPosition() {
    guard let activeVector else { return }
    
    let vector = vectors.first(where: { $0.vector.name == activeVector.name })!
    
    let newStartPoint = CGPoint(x: activeVector.position.x * CGFloat(SceneSize.height),
                                y: activeVector.position.y * CGFloat(SceneSize.height))
    let newEndPoint = CGPoint(x: newStartPoint.x + vector.endPoint.x - vector.startPoint.x,
                              y: newStartPoint.y + vector.endPoint.y - vector.startPoint.y)
    
    updateVectorPositionUseCase.execute(withVector: vector,
                                        withStartPoint: newStartPoint,
                                        withEndPoint: newEndPoint)
    
    vector.startPoint = newStartPoint
    vector.endPoint = newEndPoint

    self.activeVector = nil
    
    viewController?.scrollView.isScrollEnabled = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchPoint = touch.location(in: self)
      let touchedNode = atPoint(touchPoint)
      
      guard let touchedNodeName = touchedNode.name else { return }
      
      switch touchedNodeName {
      case let name where name.hasPrefix(SpriteNodeName.vector):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode
        
        touchOffsetX = touchPoint.x - touchedNode.position.x
        touchOffsetY = touchPoint.y - touchedNode.position.y
        
      case let name where name.hasPrefix(SpriteNodeName.holder):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode.parent
        
        touchOffsetX = 0
        touchOffsetY = 0
        
      case let name where name.hasPrefix(SpriteNodeName.arrow):
        viewController?.scrollView.isScrollEnabled = false
        
        activeVector = touchedNode.parent
        
        guard let vector = vectors.first(where: { $0.vector.name == activeVector?.name })
        else {
          return
        }
        
        touchOffsetX = (vector.endPoint.x - vector.startPoint.x) / CGFloat(SceneSize.width)
        touchOffsetY = (vector.endPoint.y - vector.startPoint.y) / CGFloat( SceneSize.height)

      default:
        break
      }
      
      activeEndNode = touchedNode
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let activeVector,
       let touchPosition = touches.first?.location(in: self) {
      activeVector.position = CGPoint(x: touchPosition.x - touchOffsetX,
                                      y: touchPosition.y - touchOffsetY)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    saveVectorPosition()
  }
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}


extension MainPresenter: UIGestureRecognizerDelegate {
  
  @objc func longPress(sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .began:
      guard let vector = vectors.first(where: { $0.vector.name == activeVector?.name })
      else {
        return
      }
      vector.changeWidthForState(changingState: true)
      
    case .changed:
      guard let activeEndNode else { return }
      
      switch activeEndNode.name! {
      case let name where name.hasPrefix(SpriteNodeName.holder):
        let newPoint = sender.location(in: viewController?.scrollView)
        
        
      case let name where name.hasPrefix(SpriteNodeName.arrow):
        var newPoint = sender.location(in: viewController?.scrollView)
        newPoint = CGPoint(x: newPoint.x - CGFloat(SceneSize.width / 2),
                           y: CGFloat(SceneSize.height) / 2 - newPoint.y )
        
        guard let vector = vectors.first(where: { $0.vector.name == activeVector?.name })
        else {
          return
        }
        
        vector.updateDataForNewPoint(newPoint, withVectorEnd: .arrow)
        
      default:
        break
      }
      
    case .ended:
      let vector = vectors.first(where: { $0.vector.name == activeVector!.name })!
      vector.changeWidthForState(changingState: false)
      
      saveVectorPosition()
      
    default:
      break
    }

  }
}
