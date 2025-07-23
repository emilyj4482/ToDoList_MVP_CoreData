//
//  EditTaskPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/22.
//  Refactored by EMILY on 2025/07/23.

import Foundation

protocol EditTaskProtocol {
    func setupUI()
    func dismiss()
}

final class EditTaskPresenter: NSObject {
    private let viewController: EditTaskViewController
    private let repository: TodoRepository
    
    init(viewController: EditTaskViewController, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController.setupUI()
    }
}
