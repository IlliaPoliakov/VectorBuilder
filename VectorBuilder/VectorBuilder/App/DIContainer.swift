//
//  DIContainer.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//

import Foundation
import Swinject

class DependencyInjectionContainer {
  public static var shared: Container = Container()
  
  public static func initialize(){
    
    // -MARK: - Data -
    
    DependencyInjectionContainer.shared.register(CoreDataManager.self) { _ in
      CoreDataManager(modelName: "DataModelFeedly")
    }
    
    DependencyInjectionContainer.shared.register(DataBaseDataSource.self) { _ in DataBaseDataSource()}
    
    
    // -MARK: - Repositories -
    

    
    // -MARK: - UseCases -
    
 
    
    // -MARK: - Presenters -
    
    DependencyInjectionContainer.shared.register(MainPresenterProtocol.self) { _ in MainPresenter() }
    DependencyInjectionContainer.shared.register(AddVectorPresenterProtocol.self) { _ in AddVectorPresenter() }

  }
}

