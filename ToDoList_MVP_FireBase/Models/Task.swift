//
//  Task.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Foundation

struct Task: Codable {
    var id = UUID().uuidString
    let listId: Int
    var title: String
    var isDone: Bool
    var isImportant: Bool
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "listId": listId,
            "title": title,
            "isDone": isDone,
            "isImportant": isImportant
        ]
        return dict
    }
    
    mutating func update(title: String, isDone: Bool, isImportant: Bool) {
        self.title = title
        self.isDone = isDone
        self.isImportant = isImportant
    }
}
