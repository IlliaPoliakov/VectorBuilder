//
//  SaveVectorUseCase.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation

class SaveNewVectorUseCase {
  private let repo: VectorRepository

  init(repo: VectorRepository) {
    self.repo = repo
  }
  
  func execute(withDataFrom uivector: UIVector) {
    repo.saveNewVector(withDataFrom: Vector.convertToModel(withUIVectors: [uivector]).first!)
  }
}
