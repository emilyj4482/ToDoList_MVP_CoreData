//
//  FirebaseManager.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/17.
//

import Firebase

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db = Database.database().reference()
    
    let testList = List(id: 1, name: "Important", tasks: [Task(listId: 1, title: "to study", isDone: false, isImportant: false), Task(listId: 1, title: "to die", isDone: false, isImportant: false)])
    let testList2 = List(id: 2, name: "Untitled list", tasks: [Task(listId: 1, title: "to die", isDone: false, isImportant: false)])
    
    var lists: [List] = []
    
    let testTask = Task(listId: 1, title: "to study", isDone: false, isImportant: false)
    let testTask2 = Task(listId: 1, title: "to die", isDone: false, isImportant: false)
    
    func test() {
        // db.child(String(testList.id)).setValue(testList.toDictionary)
        // db.child(String(testList2.id)).setValue(testList2.toDictionary)
        
        // lists.append(testList)
        // lists.append(testList2)
        
        // let children = lists.map { String($0.id) }

        /*
        children.forEach {
            db.child($0).observeSingleEvent(of: .value) { snapshot in
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
                    let decoder = JSONDecoder()
                    let list: List = try decoder.decode(List.self, from: data)
                    // print(list)
                } catch let error {
                    print("ERROR >>> \(error.localizedDescription)")
                }
            }
        }
        */
        
        // lists.append(testList.toDictionary)
        // lists.append(testList2.toDictionary)
        
        // db.setValue(lists)
        
        db.observeSingleEvent(of: .value) { snapshot in
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
                let decoder = JSONDecoder()
                let array: [List] = try decoder.decode([List].self, from: data)
                self.lists = array
                // print(self.lists)
                // ui update
                DispatchQueue.main.async {
                    print(array)
                }
            } catch let error {
                print("ERROR >>> \(error.localizedDescription)")
            }
        }
        
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print(self.lists)
        }
         */
        
    }
}
