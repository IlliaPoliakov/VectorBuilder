//
//  MainViewController.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SnapKit
import SpriteKit
import Then

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
  
  private(set) var scrollView: UIScrollView!
  
  private(set) var spriteKitView: SKView!
  
  private var addVectorButton: UIButton!
  
  
  // -MARK: - Funcs -
  
  private func setupViews() {
    
    scrollView = UIScrollView().then { scrollView in
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.bounces = false
    }
    
    spriteKitView = SKView().then { skView in
      skView.translatesAutoresizingMaskIntoConstraints = false
      skView.ignoresSiblingOrder = true
      
      let scene = presenter as! SKScene
      skView.presentScene(scene)
    }
    
    addVectorButton = UIButton().then { button in
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(systemName: "plus"), for: .normal)
      button.tintColor = Colors.mainColorClear
      button.layer.borderWidth = ButtonData.borderWidth
      button.layer.borderColor = ButtonData.borderColor.cgColor
      button.layer.cornerRadius = ButtonData.cornerRadius
      button.backgroundColor = ButtonData.backgroundColor
      button.addAction(UIAction(handler: {_ in self.presenter.addVectorButtonTupped()}),
                       for: .touchUpInside)
    }
  }
  
  private func layoutViews() {
    self.view.addSubview(scrollView)
    self.view.addSubview(addVectorButton)
    scrollView.addSubview(spriteKitView)
    
    scrollView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    
    spriteKitView.snp.makeConstraints { make in
      make.top.trailing.bottom.leading.equalToSuperview()
      make.width.equalTo(2400)
      make.height.equalTo(1600)
    }
    
    addVectorButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-30)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
      make.width.height.equalTo(self.view.bounds.width / 10)
    }
  }
  
}
