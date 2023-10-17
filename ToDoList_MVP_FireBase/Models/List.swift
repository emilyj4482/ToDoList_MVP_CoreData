//
//  List.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Foundation

struct List: Codable {
    let id: Int
    var name: String
    var tasks: [Task]
    
    var toDictionary: [String: Any] {
        
        let tasksArray = tasks.map { $0.toDictionary }
        
        let dict: [String: Any] = [
            "id": id,
            "name": name,
            "tasks": tasksArray
        ]
        
        return dict
    }
    
    mutating func update(name: String) {
        self.name = name
    }
}
