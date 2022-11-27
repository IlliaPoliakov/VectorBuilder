//
//  Router.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit


final class Router {
  
  static var shared: Router = Router()
  
  // -MARK: - Properties -
  
  var navigationController: UINavigationController = {
    var navigationConrtoller = UINavigationController()
    navigationConrtoller.isToolbarHidden = false
    navigationConrtoller.isNavigationBarHidden = false
    
    navigationConrtoller.navigationBar.tintColor = Colors.color(.mainColorClear)()
    
    return navigationConrtoller
  }()
  
  lazy var mainViewController: UIViewController = {
    let presenter: MainPresenterProtocol =
    AppDelegate.DIContainer.resolve(MainPresenterProtocol.self)!
    
    let viewController: MainViewController = MainViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
}
