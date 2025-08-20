//
//  MainListCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class MainListCoordinator: Coordinator {
    var childCoordinators =  [Coordinator]()
    var navigationController: UINavigationController
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        let viewController = MainListViewController(repository: repository)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAddListView() {
        let addListCoordinator = AddListCoordinator(navigationController: navigationController, repository: repository)
        addListCoordinator.parentCoordinator = self
        childCoordinators.append(addListCoordinator)
        addListCoordinator.start()
    }
    
    func showTodoListView(with list: ListEntity) {
        let todoListCoordinator = TodoListCoordinator(navigationController: navigationController, repository: repository)
        todoListCoordinator.parentCoordinator = self
        childCoordinators.append(todoListCoordinator)
        todoListCoordinator.start(with: list)
    }
}
