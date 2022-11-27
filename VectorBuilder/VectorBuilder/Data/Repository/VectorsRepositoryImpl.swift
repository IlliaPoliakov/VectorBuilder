//
//  VectorsRepositoryImpl.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation

final class VectorRepositoryImpl: VectorRepository {
  
  // -MARK: - Properties -
  
  private var parser = XMLDataParser()
  
  private let localDataSource: DataBaseDataSource
  
  init(localDataSource: DataBaseDataSource) {
    self.localDataSource = localDataSource
  }
  
  
  // -MARK: - UseCase Funcs -
  
  func getVectors() -> AnyPublisher<[Vector], Never> {
    let publisher = PassthroughSubject<[Feed], Never>()
    
    DispatchQueue.global(qos: .userInitiated).async {
      let vectorEntities = self.localDataSource.loadVectors()
      
      if let vectorEntities {
        let vectors = VectorEntity.convertToDomain(withEntities: vectorEntities)
        DispatchQueue.main.async {
          publisher.send(feeds)
        }
      }
      
      DispatchQueue.main.async {
        publisher.send(completion: .finished)
      }
    }
    
    return publisher.eraseToAnyPublisher()
  }
}
