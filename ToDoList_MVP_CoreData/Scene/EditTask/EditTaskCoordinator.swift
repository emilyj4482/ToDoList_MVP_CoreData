//
//  EditTaskCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class EditTaskCoordinator: Coordinator {
    weak var parentCoordinator: TodoListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start(with mode: EditTaskMode) {
        var viewController: EditTaskViewController
        
        switch mode {
        case .create(let listID):
            viewController = EditTaskViewController(repository: repository, mode: .create(listID: listID))
        case .retitle(let task):
            viewController = EditTaskViewController(repository: repository, mode: .retitle(task: task))
        }
        
        viewController.coordinator = self
        self.navigationController.present(viewController, animated: true)
    }
    
    func finish(shouldDismiss: Bool) {
        if shouldDismiss {
            navigationController.dismiss(animated: true) { [weak self] in
                self?.parentCoordinator?.childDidFinish(self)
            }
        } else {
            parentCoordinator?.childDidFinish(self)
        }
    }
}
