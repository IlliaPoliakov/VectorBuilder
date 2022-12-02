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
      CoreDataManager.shared
    }
    
    DependencyInjectionContainer.shared.register(DataBaseDataSource.self) { _ in DataBaseDataSource()}
    
    
    // -MARK: - Repositories -
    
    DependencyInjectionContainer.shared.register(VectorRepository.self) { resolver in
      VectorRepositoryImpl(localDataSource: resolver.resolve(DataBaseDataSource.self)!)
    }
    
    // -MARK: - UseCases -
    
    DependencyInjectionContainer.shared.register(GetVectorsUseCase.self) { resolver in
      GetVectorsUseCase(repo: resolver.resolve(VectorRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(SaveNewVectorUseCase.self) { resolver in
      SaveNewVectorUseCase(repo: resolver.resolve(VectorRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(DeleteVectorUseCase.self) { resolver in
      DeleteVectorUseCase(repo: resolver.resolve(VectorRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(UpdateVectorPositionUseCase.self) { resolver in
      UpdateVectorPositionUseCase(repo: resolver.resolve(VectorRepository.self)!)
    }
    
    
    // -MARK: - Presenters -
    
    DependencyInjectionContainer.shared.register(MainPresenterProtocol.self) { _ in MainPresenter() }
    DependencyInjectionContainer.shared.register(SideBarPresenterProtocol.self) { _ in SideBarPresenter() }
    DependencyInjectionContainer.shared.register(AddVectorPresenterProtocol.self) { _ in
      AddVectorPresenter()
    }
  }
}

