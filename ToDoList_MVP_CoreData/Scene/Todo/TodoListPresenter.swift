//
//  TodoListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit
import CoreData

protocol TodoListProtocol {
    func setupNavigationBar()
    func setupUI()
    func hideButtonsIfNeeded()
    func setupContainerView()
}

class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    private let repository: TodoRepository
    
    private let list: ListEntity
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let controller = NSFetchedResultsController(
            fetchRequest: repository.tasksFetchRequest(for: list),
            managedObjectContext: repository.viewContext,
            sectionNameKeyPath: nil,
            cacheName: Keys.fetchedResultsControllerTaskCacheName
        )
        
        controller.delegate = self
        return controller
    }()
    
    init(
        viewController: TodoListProtocol,
        repository: TodoRepository,
        list: ListEntity
    ) {
        self.viewController = viewController
        self.repository = repository
        self.list = list
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupNavigationBar()
        viewController.setupContainerView()
        viewController.hideButtonsIfNeeded()
        loadTasks()
    }
    
    func rightBarButtonTapped() {
        
    }
    
    func addTaskButtonTapped() {
        
    }
}

extension TodoListPresenter {
    func loadTasks() {
        
    }
    
    func numberOfRows() -> Int {
        0
    }
}

extension TodoListPresenter: NSFetchedResultsControllerDelegate {
    
}
