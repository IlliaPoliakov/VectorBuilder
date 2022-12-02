//
//  VectorsRepositoryImpl.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation
import Combine

final class VectorRepositoryImpl: VectorRepository {
  
  // -MARK: - Properties -
  
  private let localDataSource: DataBaseDataSource
  
  init(localDataSource: DataBaseDataSource) {
    self.localDataSource = localDataSource
  }
  
  
  // -MARK: - UseCase Funcs -
  
  func getVectors() -> AnyPublisher<[Vector], Never> {
    let publisher = PassthroughSubject<[Vector], Never>()
    
    DispatchQueue.global(qos: .userInitiated).async {
      if let vectorEntities = self.localDataSource.loadVectors() {
        let vectors = VectorEntity.convertToDomain(withEntities: vectorEntities)
        DispatchQueue.main.async {
          publisher.send(vectors)
        }
      }
      
      DispatchQueue.main.async {
        publisher.send(completion: .finished)
      }
    }
    
    return publisher.eraseToAnyPublisher()
  }
  
  func saveNewVector(withDataFrom modelVector: Vector) {
    localDataSource.saveNewVector(withDatafrom: modelVector)
  }
  
  func deleteVector(withDataFrom modelVector: Vector) {
    localDataSource.deleteVector(withDataFrom: modelVector)
  }
  
  func updateVectorPosition(withVector vector: Vector,
                            withStartPoint startPoint: CGPoint,
                            withEndPoint endPoint: CGPoint) {
    localDataSource.updateVectorPosition(withVector: vector,
                                         withStartPoint: startPoint,
                                         withEndPoint: endPoint)
  }
}
