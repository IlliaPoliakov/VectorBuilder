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
    let fetchRequest = VectorEntity.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(key: "startX", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.coreDataManager.managedObjectContext,
        sectionNameKeyPath: nil,
        cacheName: nil)

    do {
        try fetchedResultsController.performFetch()
    } catch {
        let fetchError = error as NSError
        print("Unable to Load Vectors")
        print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let vectors = fetchedResultsController.fetchedObjects
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
    
    do {
        try newVector.managedObjectContext?.save()
    } catch {
        let saveError = error as NSError
        print("Unable to Save Note")
        print("\(saveError), \(saveError.localizedDescription)")
    }
  }
  
  func deleteVector(withDataFrom modelVector: Vector) {
    let vectorsFetchRequest = NSFetchRequest<VectorEntity>(entityName: "VectorEntity")
    
    let vectorsPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(VectorEntity.hexColor),
      "\(modelVector.colorHex)"
    )
    
    let vectorsSortDescriptor = NSSortDescriptor(key: "startX", ascending: false)
    
    vectorsFetchRequest.sortDescriptors = [vectorsSortDescriptor]
    vectorsFetchRequest.predicate = vectorsPredicate
    
    let vectorsFetchedResultsController = NSFetchedResultsController(
      fetchRequest: vectorsFetchRequest,
      managedObjectContext: self.coreDataManager.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      try vectorsFetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Save Note")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    guard let vectors = vectorsFetchedResultsController.fetchedObjects,
          !vectors.isEmpty
    else {
      print("CoreData items-fetch is failed")
      return
    }
    
    let filteredVectors = vectors.filter { vector in
      vector.startX == modelVector.startPoint.x &&
      vector.startY == modelVector.startPoint.y &&
      vector.endX == modelVector.endPoint.x &&
      vector.endY == modelVector.endPoint.y
    }
    
    guard let vector = filteredVectors.first
    else {
      return
    }
    
    coreDataManager.managedObjectContext.delete(vector)
    
    try? coreDataManager.managedObjectContext.save()
  }
}
