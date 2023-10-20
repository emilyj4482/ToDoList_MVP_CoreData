//
//  FirebaseManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Firebase

final class FirebaseManager {
    
    let testList = List(id: 1, name: "Important", tasks: [Task(listId: 1, title: "to study", isDone: false, isImportant: false), Task(listId: 1, title: "to die", isDone: false, isImportant: false)])
    let testList2 = List(id: 2, name: "Untitled list", tasks: [Task(listId: 1, title: "to die", isDone: false, isImportant: false)])

    let testTask = Task(listId: 1, title: "to study", isDone: false, isImportant: false)
    let testTask2 = Task(listId: 1, title: "to die", isDone: false, isImportant: false)

}
