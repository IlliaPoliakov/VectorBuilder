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
  func addVectorButtonTupped(withStartPointX: String?,
                             withStartPointY: String?,
                             withEndPointX: String?,
                             withEndPointY: String?,
                             withLength: String?)
}

final class AddVectorPresenter: AddVectorPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: AddVectorViewController?
 
  
  // -MARK: - Properties -
 
  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as? AddVectorViewController)
  }
  
  func addVectorButtonTupped(withStartPointX: String?,
                             withStartPointY: String?,
                             withEndPointX: String?,
                             withEndPointY: String?,
                             withLength: String?) {
    
  }
}
