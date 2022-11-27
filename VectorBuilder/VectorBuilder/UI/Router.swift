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
  
  lazy var addVectorViewController: UIViewController = {
    let presenter: AddVectorPresenterProtocol =
    AppDelegate.DIContainer.resolve(AddVectorPresenterProtocol.self)!
    
    let viewController: UIViewController = AddVectorViewController(presenter)
    viewController.modalPresentationStyle = .pageSheet
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  
  // -MARK: - Funcs -
  
  func presentAddVectorViewController() {
    mainViewController.present(addVectorViewController, animated: true)
  }
  
  func dismissAddVectorViewController(){
//    addFeedViewController.dismiss(animated: true)
//    guard let viewController = mainViewController as? MainViewController
//    else {
//      return
//    }
//
//    viewController.presenter.intialize()
  }
  
}
