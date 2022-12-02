//
//  VectorRepositoryProtocol.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import Foundation
import Combine

protocol VectorRepository {
  func getVectors() -> AnyPublisher<[Vector], Never>
  func saveNewVector(withDataFrom modelVector: Vector)
  func deleteVector(withDataFrom modelVector: Vector)
  func updateVectorPosition(withVector vector: Vector,
                            withStartPoint startPoint: CGPoint,
                            withEndPoint endPoint: CGPoint)
}
