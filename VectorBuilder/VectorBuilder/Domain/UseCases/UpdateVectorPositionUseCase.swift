//
//  UpdateVectorPositionUseCase.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 1.12.22.
//

import Foundation


final class UpdateVectorPositionUseCase {
  private let repo: VectorRepository

  init(repo: VectorRepository) {
    self.repo = repo
  }
  
  func execute(withVector vector: UIVector,
               withStartPoint startPoint: CGPoint,
               withEndPoint endPoint: CGPoint) {
    repo.updateVectorPosition(withVector: Vector.convertToModel(withUIVectors: [vector]).first!,
                              withStartPoint: startPoint,
                              withEndPoint: endPoint)
  }
}
