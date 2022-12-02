//
//  ContainerViewController.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 30.11.22.
//

import UIKit


final class ContainerViewController: UIViewController, MainPresenterDelegete {
  
  init(_ mainViewController: MainViewController,
       _ sideBarViewController: SideBarViewController) {
    self.mainViewController = mainViewController
    self.sideBarViewController = sideBarViewController
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mainViewController.view)
    addChild(mainViewController)
    view.insertSubview(sideBarViewController.view, at: 0)
    addChild(sideBarViewController)
  }
  
  
  // -MARK: - Properties -
  
  private var isSideBarOpened: Bool = false
  
  
  // -MARK: - Dependencies -
  
  private var mainViewController: MainViewController
  
  private var sideBarViewController: SideBarViewController
  
  
  // -MARK: - Funcs
  
  func toggleSideBar() {
    if !isSideBarOpened {
      sideBarViewController.presenter.initialize()
      
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.8,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut) {
        self.mainViewController.view.frame.origin.x =
        self.mainViewController.view.frame.width / 3 + 5
        self.sideBarViewController.collectionView.alpha = 1
      }
    }
    else {
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.8,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut) {
        self.mainViewController.view.frame.origin.x = 0
        self.sideBarViewController.collectionView.alpha = 0
      }
    }
    
    isSideBarOpened = !isSideBarOpened
  }
}
