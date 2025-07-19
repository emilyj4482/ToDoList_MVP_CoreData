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
    private let repository: TodoRepository
    
    init(viewController: MainListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupContainerView()
    }
    
    func addListButtonTapped() {
        viewController.presentAddListViewController()
    }
}
