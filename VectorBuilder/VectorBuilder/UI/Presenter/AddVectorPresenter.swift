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
    if let length {
      if let startX, let startY, let endX, let endY {
        AppDelegate.router.presentVectorDataColisionAlert { state in
          if state == .withLength {
            //do
          }
          else {
            //do
          }
        }
      }
      else {
        //do
      }
    }
    else {
      guard let startX, let startY, let endX, let endY
      else {
        AppDelegate.router.presentWarningAlert(withTitle: AlertData.wrongData,
                                               withBody: AlertData.wrongDataBody)
        return
      }
      
      // do
    }
  }
}
