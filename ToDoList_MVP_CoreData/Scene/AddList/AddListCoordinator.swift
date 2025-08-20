//
//  AddListCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class AddListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    private let onFinish: (AddListCoordinator) -> Void
    
    init(
        navigationController: UINavigationController,
        repository: TodoRepository,
        onFinish: @escaping (AddListCoordinator) -> Void
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.onFinish = onFinish
    }
    
    func start() {
        let viewController = AddListViewController(repository: repository)
        viewController.coordinator = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.present(navigationController, animated: true)
    }
    
    func finish() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            onFinish(self)
        }
    }
}
