//
//  TodoRepository.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/18.
//

import Foundation
import CoreData

final class TodoRepository {
    private let coreDataManager = CoreDataManager.shared
    
    func createList(name: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let list = List(context: backgroundContext)
            list.name = name
            
            try backgroundContext.save()
        }
    }
    
    func renameList(objectID: NSManagedObjectID, newName: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? List else {
                throw CoreDataError.castingObjectFailed
            }
            
            list.name = newName
            try backgroundContext.save()
        }
    }
    
    func deleteList(objectID: NSManagedObjectID) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? List else {
                throw CoreDataError.castingObjectFailed
            }
            
            backgroundContext.delete(list)
            try backgroundContext.save()
        }
    }
    
    // doesn't need async/await because : 1) fetching from viewContext is very quick 2) it's main thread operation
    // doesn't need throws because : 1) fetch errors are genuinely rare 2) UI needs to handle empty state anyway - just returning empty array [] is better scenario
    func fetchLists() -> [List] {
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        
        do {
            return try coreDataManager.viewContext.fetch(fetchRequest)
        } catch {
            print("[Repository] Failed to fetch lists: \(error.localizedDescription)")
            return []
        }
    }
}
