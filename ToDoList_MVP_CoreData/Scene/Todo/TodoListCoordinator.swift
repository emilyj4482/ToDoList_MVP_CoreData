//
//  TodoListCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class TodoListCoordinator: Coordinator {
    weak var parentCoordinator: MainListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start(with list: ListEntity) {
        let viewController = TodoListViewController(repository: repository, list: list)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish(shouldPop: Bool) {
        if shouldPop {
            navigationController.popViewController(animated: true)
        }
        parentCoordinator?.childDidFinish(self)
    }
    
    func showEditTaskView(with mode: EditTaskMode) {
        let editTaskCoordinator = EditTaskCoordinator(navigationController: navigationController, repository: repository)
        editTaskCoordinator.parentCoordinator = self
        childCoordinators.append(editTaskCoordinator)
        editTaskCoordinator.start(with: mode)
    }
}
