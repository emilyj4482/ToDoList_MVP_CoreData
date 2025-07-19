//
//  MainListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/18.

import Foundation

protocol MainListProtocol {
    func setupUI()
    func setupContainerView()
    func presentAddListViewController()
}

final class MainListPresenter: NSObject {
    private let viewController: MainListProtocol
    private let todoManaer: TodoManager
    
    init(viewController: MainListProtocol, todoManager: TodoManager) {
        self.viewController = viewController
        self.todoManaer = todoManager
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupContainerView()
    }
    
    func addListButtonTapped() {
        viewController.presentAddListViewController()
    }
}
