//
//  AddVectorPresenter.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SpriteKit

protocol AddVectorPresenterProtocol {
  func assignViewController(_ viewController: UIViewController)
  func addVectorButtonTupped(withStartPointX startX: String?,
                             withStartPointY startY: String?,
                             withEndPointX endX: String?,
                             withEndPointY endY: String?,
                             withLength length: String?)
}

final class AddVectorPresenter: AddVectorPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: AddVectorViewController?
  
  private let saveNewVectorUseCase: SaveNewVectorUseCase =
  AppDelegate.DIContainer.resolve(SaveNewVectorUseCase.self)!
 
  
  // -MARK: - Properties -
 
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? AddVectorViewController)
  }
  
  func addVectorButtonTupped(withStartPointX startX: String?,
                             withStartPointY startY: String?,
                             withEndPointX endX: String?,
                             withEndPointY endY: String?,
                             withLength length: String?) {
    if let lengthStr = length,
       let length = Int(lengthStr){
      if let startXStr = startX, let startYStr = startY, let endXStr = endX, let endYStr = endY,
         let startX = Int(startXStr), let startY = Int(startYStr), let endX = Int(endXStr),
         let endY = Int(endYStr){
        AppDelegate.router.presentVectorDataColisionAlert { state in
          if state == .withLength {
            let vector = UIVector(startPoint: CGPoint(x: 10, y: 10),
                                  endPoint: CGPoint(x: 10 + length, y: 10),
                                  color: .random())
            
            self.saveNewVectorUseCase.execute(withDataFrom: vector)
            self.viewController?.erraseAllTextFields()
            AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
          }
          else {
            let vector = UIVector(startPoint: CGPoint(x: startX, y: startY),
                                  endPoint: CGPoint(x: endX, y: endY),
                                  color: .random())
            
            self.saveNewVectorUseCase.execute(withDataFrom: vector)
            self.viewController?.erraseAllTextFields()
            AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
          }
        }
      }
      else {
        let vector = UIVector(startPoint: CGPoint(x: 10, y: 10),
                              endPoint: CGPoint(x: 10 + length, y: 10),
                              color: .random())
        
        self.saveNewVectorUseCase.execute(withDataFrom: vector)
        viewController?.erraseAllTextFields()
        AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
      }
    }
    else {
      guard let startXStr = startX, let startYStr = startY, let endXStr = endX, let endYStr = endY,
            let startX = Int(startXStr), let startY = Int(startYStr), let endX = Int(endXStr),
            let endY = Int(endYStr)
      else {
        AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongData,
                                               withBody: AlertData.wrongDataBody)
        return
      }
      
      let vector = UIVector(startPoint: CGPoint(x: startX, y: startY),
                            endPoint: CGPoint(x: endX, y: endY),
                            color: .random())
      
      self.saveNewVectorUseCase.execute(withDataFrom: vector)
      viewController?.erraseAllTextFields()
      AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
    }
  }
}
