//
//  TodoListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

protocol TodoListProtocol {
    
}

final class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    
    init(viewController: TodoListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        
    }
}
