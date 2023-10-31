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
    
    func deleteList(index: Int) {
        lists.remove(at: index)
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
    
    private func updateSingleTask(listId: Int, taskId: String, task: Task) {
        if let index1 = lists.firstIndex(where: { $0.id == listId }),
           let index2 = lists[index1].tasks?.firstIndex(where: { $0.id == taskId }) {
            lists[index1].tasks?[index2].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
    }
    
    private func reloadViewWhenTaskUpdated(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
    }
    
    // important task인 경우 Important list와 속한 list 양쪽에서 업데이트 필요
    func updateTask(_ task: Task) {
        if task.isImportant {
            updateSingleTask(listId: 1, taskId: task.id, task: task)
        }
        updateSingleTask(listId: task.listId, taskId: task.id, task: task)
        
        // view reload
        reloadViewWhenTaskUpdated(task)
        saveData()
    }
    
    // isImportant update : Important list로의 추가/삭제 함께 동작 필요
    func updateImportant(_ task: Task) {
        if task.isImportant && lists[0].tasks == nil {
            lists[0].tasks = [task]
        } else if task.isImportant && lists[0].tasks != nil {
            lists[0].tasks?.append(task)
        } else if !task.isImportant {
            if let index = lists[0].tasks?.firstIndex(where: { $0.id == task.id }) {
                lists[0].tasks?.remove(at: index)
                // 현재 view가 Important list일 경우 view reload
                if list?.id == 1 {
                    tasks.remove(at: index)
                }
            }
        }
        updateSingleTask(listId: task.listId, taskId: task.id, task: task)
        
        // view reload
        reloadViewWhenTaskUpdated(task)
        saveData()
    }
    
    private func deleteSingleTask(listId: Int, taskId: String) {
        if let index = lists.firstIndex(where: { $0.id == listId }) {
            lists[index].tasks?.removeAll(where: { $0.id == taskId })
        }
    }
    
    // important task인 경우 Important group과 task가 속한 group 양쪽에서 삭제 필요
    func deleteTask(index: Int) {
        let task = tasks[index]
        if task.isImportant {
            deleteSingleTask(listId: 1, taskId: task.id)
        }
        deleteSingleTask(listId: task.listId, taskId: task.id)
        
        // view reload
        tasks.remove(at: index)
        saveData()
    }
    
    // task.isDone 여부에 따라 section을 분리하기 위해 tasks filter
    func unDoneTasks() -> [Task] {
        guard
            let list = list,
            let index = lists.firstIndex(where: { $0.id == list.id }),
            let tasks = lists[index].tasks
        else { return [] }
        return tasks.filter({ !$0.isDone })
    }
    
    func isDoneTasks() -> [Task] {
        guard
            let list = list,
            let index = lists.firstIndex(where: { $0.id == list.id }),
            let tasks = lists[index].tasks
        else { return [] }
        return tasks.filter({ $0.isDone })
    }
}
