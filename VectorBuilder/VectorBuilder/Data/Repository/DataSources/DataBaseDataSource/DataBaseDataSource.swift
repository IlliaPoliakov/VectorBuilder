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
    
//    let sortDescriptor = NSSortDescriptor(key: "startX", ascending: false)
    fetchRequest.sortDescriptors = []////////////////////////////////////////////////////////////////////////////////////////////////

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
    
    guard let vectors = fetchedResultsController.fetchedObjects,
          !vectors.isEmpty
    else {
      print("CoreData vector-fetch is failed")
      return nil
    }
    
    return vectors
  }
}
