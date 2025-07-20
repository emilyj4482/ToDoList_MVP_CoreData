//
//  CoreDataManager.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/19.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Key.container)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("[Core Data] failed to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        return container
        
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
}

extension CoreDataManager {
    struct Key {
        static let container = "Todo"
    }
}
