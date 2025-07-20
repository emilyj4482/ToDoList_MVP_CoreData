//
//  AddListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/19.

import Foundation

protocol AddListProtocol {
    func setupUI()
    func dismiss()
}

final class AddListPresenter: NSObject {
    private let viewController: AddListProtocol
    private let repository: TodoRepository
    
    init(viewController: AddListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController.setupUI()
    }
    
    func leftBarButtonTapped() {
        viewController.dismiss()
    }
    
    func rightBarButtonTapped() {
        // TODO: add list logic
        viewController.dismiss()
    }
}
