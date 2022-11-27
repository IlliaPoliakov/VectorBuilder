//
//  MainViewController.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SnapKit
import SpriteKit

final class MainViewController: UIViewController {
  
  init(_ presenter: MainPresenterProtocol){
    self.presenter = presenter
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    layoutViews()
  }
  
  
  // -MARK: - Dependencies -
  
  private(set) var presenter: MainPresenterProtocol
  
  
  // -MARK: - Views -
  
  private var scrollView: UIScrollView!
  
  private var spriteKitView: SKView!
  
  
  // -MARK: - Funcs -
  
  private func setupViews() {
    scrollView = {
      let scrollView = UIScrollView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.bounces = false
      scrollView.insetsLayoutMarginsFromSafeArea = false
      return scrollView
    }()
    
    spriteKitView = {
      let skView = SKView()
      skView.ignoresSiblingOrder = false
      skView.presentScene((presenter  as! SKScene))
      
      return skView
    }()
  }
  
  private func layoutViews() {
    self.view.addSubview(scrollView)
    scrollView.addSubview(spriteKitView)
    
    scrollView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    
    spriteKitView.snp.makeConstraints { make in
      make.top.trailing.bottom.leading.equalToSuperview()
      make.width.equalTo(2560)
      make.height.equalTo(1600)
    }
  }
  
}
