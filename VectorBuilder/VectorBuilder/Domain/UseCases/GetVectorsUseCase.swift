//
//  GetVectorsUseCase.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation
import Combine

final class GetVectorsUseCase {
  private let repo: VectorRepository

  init(repo: VectorRepository) {
    self.repo = repo
  }
  
  func execute() -> AnyPublisher<[UIVector], Never> {
    repo.getVectors()
      .map { vectors in
        return Vector.convertToUI(withModels: vectors)
      }
      .eraseToAnyPublisher()
  }
}
