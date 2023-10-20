//
//  FirebaseManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/20.
//

import Firebase

final class FirebaseManager {
    private let db = Database.database().reference()
    
    func addList(_ lists: [List]) {
        let data = lists.map { list in
            list.toDictionary
        }
        db.setValue(data)
    }
}
