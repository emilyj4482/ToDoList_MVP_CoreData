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
            // 현재 Entity 개수 fetch
            let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
            let currentCount = try backgroundContext.count(for: fetchRequest)
            
            let list = ListEntity(context: backgroundContext)
            list.name = name
            list.orderIndex = Int64(currentCount)
            
            try backgroundContext.save()
        }
    }
    
    func renameList(objectID: NSManagedObjectID, newName: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? ListEntity else {
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
            
            guard let list = managedObject as? ListEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            backgroundContext.delete(list)
            try backgroundContext.save()
        }
    }
    
    // doesn't need async/await because : 1) fetching from viewContext is very quick 2) it's main thread operation
    // doesn't need throws because : 1) fetch errors are genuinely rare 2) UI needs to handle empty state anyway - just returning empty array [] is better scenario
    func fetchLists() -> [ListEntity] {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        
        do {
            return try coreDataManager.viewContext.fetch(fetchRequest)
        } catch {
            print("[Repository] Failed to fetch lists: \(error.localizedDescription)")
            return []
        }
    }
}

extension TodoRepository {
    func createImportantListIfNeeded() async throws {
        // check if Important list already exists
        if try await getImportantList() != nil {
            return
        }
        
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let list = ListEntity(context: backgroundContext)
            list.name = "Important"
            list.orderIndex = 0
            
            try backgroundContext.save()
        }
    }
    
    private func getImportantList() async throws -> ListEntity? {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Important")
        fetchRequest.fetchLimit = 1
        
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        return try await backgroundContext.perform {
            return try backgroundContext.fetch(fetchRequest).first
            
        }
    }
}
