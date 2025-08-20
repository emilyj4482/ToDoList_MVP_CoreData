//
//  EditTaskCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

final class EditTaskCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    private let onFinish: (EditTaskCoordinator) -> Void
    
    init(
        navigationController: UINavigationController,
        repository: TodoRepository,
        onFinish: @escaping (EditTaskCoordinator) -> Void
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.onFinish = onFinish
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
    
    func finish() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            onFinish(self)
        }
    }
}
