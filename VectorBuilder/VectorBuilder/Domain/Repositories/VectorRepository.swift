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
}
