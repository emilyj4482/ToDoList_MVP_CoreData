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
        // xcode 버그로 Optional 체크를 해제하였음에도 id가 옵셔널로 정의되어 있어 옵셔널 바인딩 필요
        guard let listID = list.id else {
            fatalError("list.id is nil. tasksFetchRequest Failed")
        }
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "listID == %@", listID as CVarArg)
        return fetchRequest
    }
    
    func tasksByDoneFetchRequest(for list: ListEntity) -> NSFetchRequest<TaskEntity> {
        // xcode 버그로 Optional 체크를 해제하였음에도 id가 옵셔널로 정의되어 있어 옵셔널 바인딩 필요
        guard let listID = list.id else {
            fatalError("list.id is nil. tasksByDoneFetchRequest Failed")
        }
        
        // undone first, then done
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "isDone", ascending: true),       // undone first, then done
            NSSortDescriptor(key: "createdDate", ascending: true)   // oldest first within each section
        ]
        fetchRequest.predicate = NSPredicate(format: "listID == %@", listID as CVarArg)
        
        return fetchRequest
    }
    
    func tasksFromImportantFetchRequest() -> NSFetchRequest<TaskEntity> {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "isDone", ascending: true),
            NSSortDescriptor(key: "createdDate", ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "isImportant == true")
        
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
    
    func fetchList(at index: Int) -> ListEntity? {
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
    
    func fetchList(with id: NSManagedObjectID) -> ListEntity? {
        let managedObject = try? viewContext.existingObject(with: id)
        guard let list = managedObject as? ListEntity else {
            return nil
        }
        return list
    }
    
    func fetchListWith(uuid: UUID, in context: NSManagedObjectContext) -> ListEntity? {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
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
            list.id = UUID()
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
        
        try await backgroundContext.perform { [weak self] in
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? ListEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            guard let request = self?.tasksFetchRequest(for: list) else {
                throw CoreDataError.etc
            }
            
            let tasks = try backgroundContext.fetch(request)
            
            // important tasks remove
            tasks.filter { $0.isImportant }.forEach {
                backgroundContext.delete($0)
            }
            
            backgroundContext.delete(list)
            
            // MARK: entity를 삭제하면 중간에 orderIndex가 비므로 순서대로 다시 부여해주어야 함
            try self?.reorderListIndexes(in: backgroundContext)
            
            try backgroundContext.save()
        }
    }
    
    private func reorderListIndexes(in context: NSManagedObjectContext) throws {
        let lists = try context.fetch(listsFetchRequest)
        
        for (index, item) in lists.enumerated() {
            item.orderIndex = Int64(index)
        }
    }
}

extension TodoRepository {
    func createImportantListIfNeeded() async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        // check if Important list already exists
        if try await getImportantList(in: backgroundContext) != nil {
            return
        }
        
        try await backgroundContext.perform {
            let list = ListEntity(context: backgroundContext)
            list.id = UUID()
            list.name = "Important"
            list.orderIndex = 0
            
            try backgroundContext.save()
        }
    }
    
    private func getImportantList(in context: NSManagedObjectContext) async throws -> ListEntity? {
        let fetchRequest: NSFetchRequest<ListEntity> = ListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "Important")
        fetchRequest.fetchLimit = 1
        
        return try await context.perform {
            return try context.fetch(fetchRequest).first
        }
    }
}

/// TaskEntity CRUD
extension TodoRepository {
    func countTasks(for list: ListEntity) -> Int {
        do {
            return try viewContext.count(for: tasksFetchRequest(for: list))
        } catch {
            print("[Repository] Failed to fetch tasks: \(error.localizedDescription)")
            return 0
        }
    }
    
    func countImportantTasks() -> Int {
        do {
            return try viewContext.count(for: tasksFromImportantFetchRequest())
        } catch {
            print("[Repository] Failed to fetch important tasks: \(error.localizedDescription)")
            return 0
        }
    }
    
    func createTask(to listID: UUID, title: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform { [weak self] in
            // Fetch the list in the SAME context where creating the task
            guard let list = self?.fetchListWith(uuid: listID, in: backgroundContext) else {
                throw CoreDataError.fetchingObjectFailed
            }
            
            let task = TaskEntity(context: backgroundContext)
            task.listID = listID
            task.title = title
            task.createdDate = Date()
            task.isDone = false
            task.isImportant = false
            
            list.addToTasks(task)
            
            try backgroundContext.save()
        }
    }
    
    func toggleTaskDone(objectID: NSManagedObjectID, isDone: Bool) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let task = managedObject as? TaskEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            task.isDone = isDone
            try backgroundContext.save()
        }
    }
    
    func toggleTaskImportant(objectID: NSManagedObjectID, isImportant: Bool) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        // 1. important list fetch
        guard let importantList = try await getImportantList(in: backgroundContext) else {
            throw CoreDataError.fetchingObjectFailed
        }
        
        // 2. fetch task
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let task = managedObject as? TaskEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            // 3. toggle important
            task.isImportant = isImportant
            // 4. add to/remove from important list
            if isImportant {
                importantList.addToTasks(task)
            } else {
                importantList.removeFromTasks(task)
            }
            
            try backgroundContext.save()
        }
    }
    
    func deleteTask(objectID: NSManagedObjectID) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform { [weak self] in
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let task = managedObject as? TaskEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            // list에서도 remove를 먼저 해줘야 NSFetchedResultsController 트리거 - MainListView reload 됨
            guard let listID = task.listID else {
                throw CoreDataError.etc
            }
            
            guard let list = self?.fetchListWith(uuid: listID, in: backgroundContext) else {
                throw CoreDataError.fetchingObjectFailed
            }
            
            list.removeFromTasks(task)
            
            backgroundContext.delete(task)
            try backgroundContext.save()
        }
    }
    
    func retitleTask(objectID: NSManagedObjectID, newTitle: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let task = managedObject as? TaskEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            task.title = newTitle
            try backgroundContext.save()
        }
    }
}
