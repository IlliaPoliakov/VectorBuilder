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
    //simply cast, ugly but normal I thhink
    let length: Int? = {
      if let str = length, let int = Int(str) { return int }
      return nil
    }()
    
    let startX: Int? = {
      if let str = startX, let int = Int(str) { return int }
      return nil
    }()
    
    let startY: Int? = {
      if let str = startY, let int = Int(str) { return int }
      return nil
    }()
    
    let endX: Int? = {
      if let str = endX, let int = Int(str) { return int }
      return nil
    }()
    
    let endY: Int? = {
      if let str = endY, let int = Int(str) { return int }
      return nil
    }()
    
    // check for LENGTH, if OK - check for POINTS, if OK - colision Alert(cause both types entered), else ...
    if let length {
      if let startX, let startY, let endX, let endY { // alert
        AppDelegate.router.presentVectorDataColisionAlert { state in
          if state == .withLength { // alert
            guard length > 0 && length < SceneSize.y
            else {
              AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongLength,
                                                     withBody: AlertData.wrongLengthBody)
              return
            }
            
            let newVector = UIVector(
              startPoint: CGPoint(x: 5, y: SceneSize.y / 2),
              endPoint: CGPoint(x: 5 + length, y: SceneSize.y / 2),
              color: .random())
            
            self.acceptWithVector(newVector)
          }
          else {
            guard startX >= 0, startY >= 0, endX >= 0, endY >= 0,
                  startX < SceneSize.x, endX < SceneSize.x &&
                    startY < SceneSize.y, endY < SceneSize.y
            else {
              AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongPoints,
                                                     withBody: AlertData.wrongPointsBody)
              return
            }
            
            let newVector = UIVector(
              startPoint: CGPoint(x: startX, y: startY),
              endPoint: CGPoint(x: endX, y: endY),
              color: .random())
            
            self.acceptWithVector(newVector)
          }
        }
      }
      else {
        guard length > 0 && length < SceneSize.y
        else {
          AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongLength,
                                                 withBody: AlertData.wrongLengthBody)
          return
        }
        let newVector = UIVector(
          startPoint: CGPoint(x: 5, y: SceneSize.y / 2),
          endPoint: CGPoint(x: 5 + length, y: SceneSize.y / 2),
          color: .random())
        
        acceptWithVector(newVector)
      }
    }
    else {
      guard let startX, let startY, let endX, let endY
      else {
        AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongData,
                                               withBody: AlertData.wrongDataBody)
        return
      }
      guard startX >= 0, startY >= 0, endX >= 0, endY >= 0,
            startX < SceneSize.x, endX < SceneSize.x &&
              startY < SceneSize.y, endY < SceneSize.y
      else {
        AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongPoints,
                                               withBody: AlertData.wrongPointsBody)
        return
      }
      
      let newVector = UIVector(
        startPoint: CGPoint(x: startX, y: startY),
        endPoint: CGPoint(x: endX, y: endY),
        color: .random())
      
      acceptWithVector(newVector)
    }
  }
  
  private func acceptWithVector(_ vector: UIVector) {
    self.saveNewVectorUseCase.execute(withDataFrom: vector)
    
    viewController?.erraseAllTextFields()
    AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
  }
}
