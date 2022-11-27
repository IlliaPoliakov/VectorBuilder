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
  
  lazy var mainViewController: UIViewController = {
    let presenter: MainPresenterProtocol =
    AppDelegate.DIContainer.resolve(MainPresenterProtocol.self)!
    
    let viewController: MainViewController = MainViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  // -MARK: - Funcs -
  
  func initialize() {
    
  }
  
  
}
