//
//  Router.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit


final class Router {
  
  static var shared: Router = Router()
  
  // -MARK: - View Controllers -
  
  // when initializing container VC, initialise main and SideBar VCs
  
  lazy var containerViewController: UIViewController = {
    let viewController: ContainerViewController =
    ContainerViewController(mainViewController as! MainViewController,
                            sideBarViewController as! SideBarViewController)
    
    let mainVC = self.mainViewController as! MainViewController
    mainVC.presenter.mainPresenterDelegete = viewController
    
    return viewController
  }()
  
  lazy var mainViewController: UIViewController = {
    let presenter: MainPresenterProtocol =
    AppDelegate.DIContainer.resolve(MainPresenterProtocol.self)!
    
    let viewController: MainViewController = MainViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    let sideBarVc = sideBarViewController as! SideBarViewController // additionaly set presenter for sideBar
    sideBarVc.presenter.assignMainPresenter(presenter)
    
    return viewController
  }()
  
  lazy var sideBarViewController: UIViewController = {
    let presenter: SideBarPresenterProtocol =
    AppDelegate.DIContainer.resolve(SideBarPresenterProtocol.self)!
    
    let viewController: UIViewController = SideBarViewController(presenter)
    
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
  
  
  // -MARK: - Functions -
  
  func presentAddVectorViewController() {
    mainViewController.present(addVectorViewController, animated: true)
  }
  
  func dismissAddVectorViewController(withNewVector vector: UIVector){
    addVectorViewController.dismiss(animated: true)
    
    guard let viewController = mainViewController as? MainViewController
    else {
      return
    }
    
    // this seems ugly, declarative aproach would be better, I'll fix it soon
    viewController.presenter.unwindFromAddViewController(withNewVector: vector)
  }
  
  
  // -MARK: - Alerts -
  
  func presentWarningAlert(withTitle title: String, withBody body: String) {
    let alert = UIAlertController(title: title,
                                  message: body,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: AlertData.ok, style: .default)
    
    alert.addAction(okAction)
    
    // look for front VC and present common Warning Alert
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    if var topController = keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      
      topController.present(alert, animated: true)
    }
  }
  
  func presentVectorDataCollisionAlert(_ completion: @escaping (VectorBuildState?) -> Void) {
    let alert = UIAlertController(title: AlertData.tooMuch,
                                  message: AlertData.bothCases,
                                  preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: CollisionAlertData.cancel,
                                     style: .default)
    let withPointsAction = UIAlertAction(title: CollisionAlertData.withPoints,
                                         style: .default) { _ in
      completion(.withPoints)
    }
    let withLengthAction = UIAlertAction(title: CollisionAlertData.withLength,
                                         style: .default) { _ in
      completion(.withLength)
    }
    
    alert.addAction(withPointsAction)
    alert.addAction(withLengthAction)
    alert.addAction(cancelAction)
    
    self.addVectorViewController.present(alert, animated: true, completion: nil)
  }
}
