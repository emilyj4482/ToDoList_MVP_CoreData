//
//  TodoListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit

protocol TodoListProtocol {
    func setupNavigationBar()
    func setupUI()
}

class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    private let repository: TodoRepository
    
    init(viewController: TodoListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController.setupUI()
    }
    
    func viewWillAppear() {
        viewController.setupNavigationBar()
    }
}
