//
//  VectorEntity+CoreDataProperties.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//
//

import Foundation
import CoreData


extension VectorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VectorEntity> {
        return NSFetchRequest<VectorEntity>(entityName: "VectorEntity")
    }

    @NSManaged public var endX: Double
    @NSManaged public var hexColor: String
    @NSManaged public var startY: Double
    @NSManaged public var endY: Double
    @NSManaged public var startX: Double

}

extension VectorEntity : Identifiable {

}
