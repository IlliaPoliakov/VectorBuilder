//
//  SaveVectorUseCase.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation

class GetVectorsUseCase {
  private let repo: VectorRepository

  init(repo: VectorRepository) {
    self.repo = repo
  }
  
  func execute() -> AnyPublisher<[Vector], Never> {
    repo.getVectors()
      .map {
        
      }
  }
}
