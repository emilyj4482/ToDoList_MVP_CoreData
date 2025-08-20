//
//  AddListCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class AddListCoordinator: Coordinator {
    weak var parentCoordinator: MainListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        let viewController = AddListViewController(repository: repository)
        viewController.coordinator = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.present(navigationController, animated: true)
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
