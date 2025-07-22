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
    
    var viewContext: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    var listsFetchRequest: NSFetchRequest<ListEntity> {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        return fetchRequest
    }
    
    func tasksFetchRequest(for list: ListEntity) -> NSFetchRequest<TaskEntity> {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "list == %@", list)
        return fetchRequest
    }
    
    // doesn't need async/await because : 1) fetching from viewContext is very quick 2) it's main thread operation
    // doesn't need throws because : 1) fetch errors are genuinely rare 2) UI needs to handle empty state anyway - just returning empty array [] is better scenario
    func fetchLists() -> [ListEntity] {
        do {
            return try viewContext.fetch(listsFetchRequest)
        } catch {
            print("[Repository] Failed to fetch lists: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchList(with index: Int) -> ListEntity? {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "orderIndex == %d", index)
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            print("[Repository] Failed to fetch list: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createList(name: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        // list name (중복)검사
        let processedName = try await processListName(name)
        
        try await backgroundContext.perform {
            // 현재 Entity 개수 fetch
            let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
            let currentCount = try backgroundContext.count(for: fetchRequest)
            
            let list = ListEntity(context: backgroundContext)
            list.name = processedName
            list.orderIndex = Int64(currentCount)
            
            try backgroundContext.save()
        }
    }
    
    func renameList(objectID: NSManagedObjectID, newName: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        // 중복 검사
        let processedName = try await processListName(newName)
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? ListEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            list.name = processedName
            try backgroundContext.save()
        }
    }
    
    private func processListName(_ input: String) async throws -> String {
        // 1. 공백 제거
        let trimmedInput = input.trim
        // 2. 완전 공백일 시 default name 부여
        let baseName = trimmedInput.isEmpty ? "Untitled List" : trimmedInput
        // 3. 기존 이름들 fetch
        let existingNames = try await getExistingListNames()
        // 4. 중복 검사 : 중복 시 (n) 붙이고 반환
        var count = 1
        var finalName = baseName
        
        while existingNames.contains(finalName) {
            finalName = "\(baseName) (\(count))"
            count += 1
        }
        
        return finalName
    }
    
    private func getExistingListNames() async throws -> [String] {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        return try await backgroundContext.perform {
            let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
            
            let results = try backgroundContext.fetch(fetchRequest)
            return results.compactMap { $0.name }
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
    
    func reorderListIndexes(for lists: [ListEntity]) throws {
        for (index, item) in lists.enumerated() {
            item.orderIndex = Int64(index)
        }
        
        if viewContext.hasChanges {
            try viewContext.save()
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
