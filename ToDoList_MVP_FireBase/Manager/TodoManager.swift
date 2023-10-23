//
//  TodoManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Foundation
import Firebase

final class TodoManager {
    
    static let shared = TodoManager()
    
    var lastListId: Int = 1     // List.id 저장용 프로퍼티
    var lists: [List] = []      // single source of truth
    var list: List? {           // main에서 todo view로 넘어갈 때 단일 list 정보 전달 받는 프로퍼티
        didSet {                // [Task]? 옵셔널 바인딩 후 collection view reload용 변수에 전달
            guard let tasks = list?.tasks else { return }
            self.tasks = tasks
        }
    }
    var tasks: [Task] = []      // todo view에서 collection view를 구성하기 위한 data 저장용 프로퍼티
    
    private let db = Database.database().reference()
    
    // firebase realtime database에 저장
    private func saveData() {
        let data = lists.map { $0.toDictionary }
        db.setValue(data)
    }
    
    private func createList(_ name: String) -> List {
        let nextId = lastListId + 1
        lastListId = nextId
        
        return List(id: nextId, name: name, tasks: [])
    }
    
    func addList(_ name: String) {
        let list = createList(name)
        lists.append(list)
        saveData()
    }
    
    func updateList(_ name: String) {
        if let index = lists.firstIndex(where: { $0.id == list?.id }) {
            lists[index].update(name: name)
        }
        saveData()
    }
    
    private func createTask(_ title: String, listId: Int) -> Task {
        return Task(listId: listId, title: title, isDone: false, isImportant: false)
    }
    
    func addTask(_ title: String) {
        if let list = list,
           let index = lists.firstIndex(where: { $0.id == list.id }) {
            
            let task = createTask(title, listId: list.id)
            
            // List model에서 tasks 프로퍼티가 옵셔널이므로, nil일 경우 append가 먹지 않아 array로 주입 필요
            if lists[index].tasks == nil {
                lists[index].tasks = [task]
            } else {
                lists[index].tasks?.append(task)
            }
            
            // view reload
            tasks.append(task)
        }
        saveData()
    }
}
