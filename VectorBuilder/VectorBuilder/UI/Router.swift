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
  
  func presentWarningAlert(withTitle title: String, withBody body: String) {
    let alert = UIAlertController(title: title,
                                  message: body,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default)
    
    alert.addAction(okAction)
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

      topController.present(alert, animated: true)
    }
    
  }
  
  func presentVectorDataColisionAlert(_ completion: @escaping (VectorBuildState?) -> Void) {
    let alert = UIAlertController(title: AlertData.tooMuch,
                                  message: AlertData.bothCases,
                                  preferredStyle: .alert)
    
    alert.addTextField { _ in }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    let withPointsAction = UIAlertAction(title: "Add", style: .cancel) { [weak alert] _ in
      completion(.withPoints)
    }
    
    let withLengthAction = UIAlertAction(title: "Add", style: .cancel) { [weak alert] _ in
      completion(.withLength)
    }
    
    alert.addAction(withPointsAction)
    alert.addAction(withLengthAction)
    alert.addAction(cancelAction)
    
    self.addVectorViewController.present(alert, animated: true, completion: nil)
  }
  
}
