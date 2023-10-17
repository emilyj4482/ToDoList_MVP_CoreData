//
//  FirebaseManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import UIKit
import Firebase

struct FirebaseManager {
    static let shared = FirebaseManager()
    
    let db = Database.database().reference()
    
    let testList = List(id: 1, name: "Important", tasks: [])
    
    func test() {
        // db.child(testList.name).setValue([String(testList.id): testList.tasks])
        // db.child("Important").removeValue()
    }
}
