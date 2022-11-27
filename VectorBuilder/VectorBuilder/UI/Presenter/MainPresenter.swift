//
//  MainPresenter.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SpriteKit

protocol MainPresenterProtocol {
  func assignViewController(_ viewController: UIViewController)
}

final class MainPresenter: SKScene, MainPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: MainViewController?
 
  
  // -MARK: - Properties -
 
  private var vectors = [UIVector]()
  
  
  // -MARK: - Funcs -
  
  override func didMove(to view: SKView) {
    
    setUpPhysics()
    setUpBackground()
//    setUpvectors()
  }
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? MainViewController)
  }
  
  private func setUpPhysics() {
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
  }
  
  private func setUpBackground() {
    let background = SKSpriteNode(imageNamed: "mainSceneBackground")
    
    background.anchorPoint = CGPoint(x: 0, y: 0)
    background.position = CGPoint(x: 0, y: 0)
    background.zPosition = Layer.background
    background.size = self.size
    
    addChild(background)
  }
  
  private func setUpVectors() {
    
  }
}

extension MainPresenter: SKPhysicsContactDelegate {
  
}
