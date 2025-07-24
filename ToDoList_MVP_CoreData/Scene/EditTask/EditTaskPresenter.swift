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
    func setupContainerView()
}

final class EditTaskPresenter: NSObject {
    private let viewController: EditTaskProtocol
    private let repository: TodoRepository
    
    private let listID: UUID
    
    init(viewController: EditTaskProtocol, repository: TodoRepository, listID: UUID) {
        self.viewController = viewController
        self.repository = repository
        self.listID = listID
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupContainerView()
    }
    
    func doneButtonTapped(with text: String) {
        Task {
            try await repository.createTask(to: listID, title: text)
        }
        viewController.dismiss()
    }
}
