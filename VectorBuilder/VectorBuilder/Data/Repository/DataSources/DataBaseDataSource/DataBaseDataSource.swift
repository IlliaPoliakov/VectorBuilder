//
//  DataBaseDataSource.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 26.11.22.
//

import Foundation
import CoreData

final class DataBaseDataSource {
  
  // -MARK: - Dependencies -
  
  private let coreDataManager = AppDelegate.DIContainer.resolve(CoreDataManager.self)!
  
  
  // -MARK: - Functions -
  
  func loadVectors() -> [VectorEntity]? {
    guard let vectors = try? coreDataManager.managedObjectContext.fetch(VectorEntity.fetchRequest())
    else {
      print("CoreData vector-fetch is failed")
      return nil
    }
    
    guard !vectors.isEmpty
    else {
      print("CoreData is empty.")
      return nil
    }
    
    return vectors
  }
  
  func saveNewVector(withDatafrom modelVector: Vector) {
    let newVector = VectorEntity(context: coreDataManager.managedObjectContext)
    
    newVector.startX = modelVector.startPoint.x
    newVector.startY = modelVector.startPoint.y
    newVector.endX = modelVector.endPoint.x
    newVector.endY = modelVector.endPoint.y
    newVector.hexColor = modelVector.colorHex
    
    try? newVector.managedObjectContext?.save()
  }
  
  func deleteVector(withDataFrom modelVector: Vector) {
    guard let vector = findVector(forModelVector: modelVector)
    else {
      return
    }
    
    coreDataManager.managedObjectContext.delete(vector)
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  func updateVectorPosition(withVector vector: Vector,
                            withStartPoint startPoint: CGPoint,
                            withEndPoint endPoint: CGPoint) {
    
    guard let vector = findVector(forModelVector: vector)
    else {
      return
    }
    
    vector.startX = startPoint.x
    vector.startY = startPoint.y
    vector.endX = endPoint.x
    vector.endY = endPoint.y
    
    try? coreDataManager.managedObjectContext.save()
  }
  
  private func findVector(forModelVector modelVector: Vector) -> VectorEntity? {
    let vectorsFetchRequest = NSFetchRequest<VectorEntity>(entityName: "VectorEntity")
    
    let vectorsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(VectorEntity.hexColor),
      "\(modelVector.colorHex)"
    )
    
    vectorsFetchRequest.predicate = vectorsPredicate
    
    guard let vectors = try? coreDataManager.managedObjectContext.fetch(VectorEntity.fetchRequest()),
          !vectors.isEmpty
    else {
      print("CoreData vector-fetch is failed")
      return nil
    }
    
    let filteredVectors = vectors.filter { vector in
      vector.startX == modelVector.startPoint.x &&
      vector.startY == modelVector.startPoint.y &&
      vector.endX == modelVector.endPoint.x &&
      vector.endY == modelVector.endPoint.y
    }
    
    guard let vector = filteredVectors.first
    else {
      return nil
    }
    
    return vector
  }
}
