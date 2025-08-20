//
//  AppCoordinator.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/08/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        guard let child else { return }
        childCoordinators.removeAll { $0 === child }
    }
}

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        let mainListCoordinator = MainListCoordinator(navigationController: navigationController, repository: repository)
        childCoordinators.append(mainListCoordinator)
        mainListCoordinator.start()
    }
}
