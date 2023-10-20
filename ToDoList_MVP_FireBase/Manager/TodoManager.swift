//
//  TodoManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Firebase

final class TodoManager {
    
    static let shared = TodoManager()
    
    private let fm = FirebaseManager()
    
    // List.id 저장용 프로퍼티
    var lastListId: Int = 1
    
    var lists: [List] = []
    
    private func createList(_ name: String) -> List {
        let nextId = lastListId + 1
        lastListId = nextId
        
        return List(id: nextId, name: name, tasks: [])
    }
    
    func addList(_ name: String) {
        let list = createList(name)
        lists.append(list)
        fm.addList(lists)
    }
}
