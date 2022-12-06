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
    
    setUpGestureRecognizer()
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
<<<<<<< HEAD
      scrollView.showsVerticalScrollIndicator = false
      scrollView.showsHorizontalScrollIndicator = false
=======
      scrollView.maximumZoomScale = 2
      scrollView.showsVerticalScrollIndicator = false
      scrollView.showsHorizontalScrollIndicator = false
      scrollView.contentInsetAdjustmentBehavior = .never
>>>>>>> release/4.0
    }
    
    spriteKitView = SKView().then { skView in
      skView.translatesAutoresizingMaskIntoConstraints = false
      skView.ignoresSiblingOrder = true
      skView.showsPhysics = true
      
      let scene = presenter as! SKScene
      skView.presentScene(scene)
    }
    
    addVectorButton = UIButton().then { button in
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(systemName: "plus"), for: .normal)
      button.tintColor = Colors.mainColorClear
      button.layer.borderWidth = ViewData.borderWidth
      button.layer.borderColor = ViewData.borderColor.cgColor
      button.layer.cornerRadius = ViewData.cornerRadius
      button.backgroundColor = Colors.viewBackgroundColor
      button.addAction(UIAction(handler: { _ in self.presenter.addVectorButtonTupped() } ),
                       for: .touchUpInside)
    }
    
    sideBarButton = UIButton().then { button in
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
      button.tintColor = Colors.mainColorClear
      button.layer.borderWidth = ViewData.borderWidth
      button.layer.borderColor = ViewData.borderColor.cgColor
      button.layer.cornerRadius = ViewData.cornerRadius
      button.backgroundColor = Colors.viewBackgroundColor
      button.addAction(UIAction(handler: { _ in self.presenter.sideBarButtonTupped() } ),
                       for: .touchUpInside)
    }
  }
  
  private func layoutViews() {
    [scrollView, addVectorButton, sideBarButton].forEach { view in
      self.view.addSubview(view)
    }
    scrollView.addSubview(spriteKitView)
    
    scrollView.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    
    spriteKitView.snp.makeConstraints { make in
      make.width.equalTo(SceneSize.width)
      make.height.equalTo(SceneSize.height)
      make.top.trailing.bottom.leading.equalToSuperview()
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
  
  private func setUpGestureRecognizer() {
    let pressed:UILongPressGestureRecognizer =
    UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
    pressed.delegate = self
    pressed.minimumPressDuration = 1
    self.view.addGestureRecognizer(pressed)
  }
}


// -MARK: - Long Press Handaling

extension MainViewController: UIGestureRecognizerDelegate {
  @objc func longPress(sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .began:
      presenter.longTapBegan()
      
    case .changed:
      presenter.longTapMoved(withSender: sender)
      
    case .ended:
      presenter.longTapEnded(withSender: sender)
    
    default:
      break
    }
  }
}

