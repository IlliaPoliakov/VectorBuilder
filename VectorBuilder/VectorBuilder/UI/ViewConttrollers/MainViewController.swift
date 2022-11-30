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
  
  var presenter: MainPresenterProtocol
  
  
  // -MARK: - Views -
  
  private(set) var scrollView: UIScrollView!
  
  private(set) var spriteKitView: SKView!
  
  private var addVectorButton: UIButton!
  
  private var sideBarButton: UIButton!
  
  
  // -MARK: - Funcs -
  
  private func setupViews() {
    
    scrollView = UIScrollView().then { scrollView in
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.bounces = false
      scrollView.maximumZoomScale = 2
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
    
    sideBarButton = UIButton().then { button in
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
      button.tintColor = Colors.mainColorClear
      button.layer.borderWidth = ButtonData.borderWidth
      button.layer.borderColor = ButtonData.borderColor.cgColor
      button.layer.cornerRadius = ButtonData.cornerRadius
      button.backgroundColor = ButtonData.backgroundColor
      button.addAction(UIAction(handler: {_ in self.presenter.sideBarButtonTupped()}),
                       for: .touchUpInside)
    }
  }
  
  private func layoutViews() {
    self.view.addSubview(scrollView)
    self.view.addSubview(addVectorButton)
    self.view.addSubview(sideBarButton)
    scrollView.addSubview(spriteKitView)
    
    scrollView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    
    spriteKitView.snp.makeConstraints { make in
      make.top.trailing.bottom.leading.equalToSuperview()
      make.width.equalTo(2700)
      make.height.equalTo(1500)
    }
    
    addVectorButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-30)
      make.bottom.equalToSuperview().offset(-40)
      make.width.height.equalTo(self.view.bounds.width / 10)
    }
    
    sideBarButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(30)
      make.top.equalToSuperview().offset(50)
      make.width.height.equalTo(self.view.bounds.width / 10)
    }
  }
  
}
