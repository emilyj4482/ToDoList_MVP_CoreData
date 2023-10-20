//
//  TodoManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Firebase

final class TodoManager {
    
    static let shared = TodoManager()
    
    // List.id 저장용 프로퍼티
    private var lastListId: Int = 1
    
    var lists: [List] = []
    
    private func createList(_ text: String) -> List {
        return List(id: 5, name: text, tasks: [])
    }
    
    func addList(_ text: String) {
        lists.append(createList(text))
    }
}
