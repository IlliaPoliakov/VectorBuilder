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
  func addVectorButtonTupped(
    withStartPointX startX: String?,
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
  
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? AddVectorViewController)
  }
  
  func addVectorButtonTupped(
    withStartPointX startX: String?,
    withStartPointY startY: String?,
    withEndPointX endX: String?,
    withEndPointY endY: String?,
    withLength length: String?) {
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
      
      // check for LENGTH, if OK - check for POINTS,
      // if OK - colision Alert(cause both types entered), else...
      if let length {
        if let startX, let startY, let endX, let endY { // alert
          AppDelegate.router.presentVectorDataCollisionAlert { state in
            if state == .withLength {
              guard length > 0 && length < SceneSize.height
              else {
                AppDelegate.router.presentWarningAlert(
                  withTitle: AlertData.wrongLength,
                  withBody: AlertData.wrongLengthBody)
                
                self.erraseAllTextFields()
                
                return
              }
              
              let newVector = UIVector(
                startPoint: CGPoint(x: 5 - SceneSize.width / 2, y: 0),
                endPoint: CGPoint(x: 5 - SceneSize.width / 2 + length, y: 0),
                color: .random())
              
              self.acceptWithVector(newVector)
            }
            else {
              guard startX >= -500, startY >= -500, endX >= -500, endY >= -500,
                    startX <= SceneSize.height, endX <= SceneSize.height,
                    startY <= SceneSize.height, endY <= SceneSize.height
              else {
                AppDelegate.router.presentWarningAlert(
                  withTitle: AlertData.wrongPoints,
                  withBody: AlertData.wrongPointsBody)
                
                self.erraseAllTextFields()
                
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
          guard length > 0 && length < SceneSize.width
          else {
            AppDelegate.router.presentWarningAlert(
              withTitle: AlertData.wrongLength,
              withBody: AlertData.wrongLengthBody)
            
            self.erraseAllTextFields()
            
            return
          }
          let newVector = UIVector(
            startPoint: CGPoint(x: 5 - SceneSize.width / 2, y: 0),
            endPoint: CGPoint(x: 5 - SceneSize.width / 2 + length, y: 0),
            color: .random())
          
          acceptWithVector(newVector)
        }
      }
      else {
        guard let startX, let startY, let endX, let endY
        else {
          AppDelegate.router.presentWarningAlert(
            withTitle: AlertData.wrongData,
            withBody: AlertData.wrongDataBody)
          
          self.erraseAllTextFields()
          
          return
        }
        guard startX >= -500, startY >= -500, endX >= -500, endY >= -500,
              startX <= SceneSize.height, endX <= SceneSize.height,
              startY <= SceneSize.height, endY <= SceneSize.height
        else {
          AppDelegate.router.presentWarningAlert(
            withTitle: AlertData.wrongPoints,
            withBody: AlertData.wrongPointsBody)
          
          self.erraseAllTextFields()
          
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
    
    self.erraseAllTextFields()
    
    AppDelegate.router.dismissAddVectorViewController(withNewVector: vector)
  }
  
  private func erraseAllTextFields() {
    viewController?.startXTextField.text = ""
    viewController?.endXTextField.text = ""
    viewController?.startYTextField.text = ""
    viewController?.endYTextField.text = ""
    viewController?.lengthTextField.text = ""
  }
}
