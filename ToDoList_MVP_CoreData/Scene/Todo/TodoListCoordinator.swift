//
//  TodoListCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class TodoListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    private let onFinish: (TodoListCoordinator) -> Void
    
    init(
        navigationController: UINavigationController,
        repository: TodoRepository,
        onFinish: @escaping (TodoListCoordinator) -> Void
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.onFinish = onFinish
    }
    
    func start(with list: ListEntity) {
        let viewController = TodoListViewController(repository: repository, list: list)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
        onFinish(self)
    }
    
    func showEditTaskView(with mode: EditTaskMode) {
        let editTaskCoordinator = EditTaskCoordinator(navigationController: navigationController, repository: repository) { [weak self] coordinator in
            self?.childCoordinators.removeAll { $0 === coordinator }
        }
        childCoordinators.append(editTaskCoordinator)
        editTaskCoordinator.start(with: mode)
    }
}
