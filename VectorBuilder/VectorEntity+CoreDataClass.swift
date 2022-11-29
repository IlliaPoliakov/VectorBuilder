//
//  VectorEntity+CoreDataClass.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//
//

import CoreData

@objc(VectorEntity)
public class VectorEntity: NSManagedObject {
  static func convertToDomain(withEntities entities: [VectorEntity]) -> [Vector] {

    return entities.map { entity in
      Vector(startPoint: CGPoint(x: entity.startX, y: entity.startY),
             endPoint: CGPoint(x: entity.endX, y: entity.endY),
             colorHex: entity.hexColor)
    }
  }
}
