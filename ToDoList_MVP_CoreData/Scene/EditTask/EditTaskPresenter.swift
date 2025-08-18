//
//  EditTaskPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/22.
//  Refactored by EMILY on 2025/07/23.

import Foundation

protocol EditTaskProtocol: AnyObject {
    func setupUI()
    func dismiss()
    func setupContainerView(mode: EditTaskMode)
    func showError(_ error: Error)
}

final class EditTaskPresenter: NSObject {
    private weak var viewController: EditTaskProtocol?
    private let repository: TodoRepository
    
    private let mode: EditTaskMode
    
    init(viewController: EditTaskProtocol, repository: TodoRepository, mode: EditTaskMode) {
        self.viewController = viewController
        self.repository = repository
        self.mode = mode
    }
    
    func viewDidLoad() {
        viewController?.setupUI()
        viewController?.setupContainerView(mode: mode)
    }
    
    func doneButtonTapped(with text: String) {
        Task {
            do {
                switch mode {
                case .create(let listID):
                    try await repository.createTask(to: listID, title: text)
                case .retitle(let task):
                    try await repository.retitleTask(objectID: task.objectID, newTitle: text)
                }
                await MainActor.run {
                    viewController?.dismiss()
                }
            } catch {
                await MainActor.run {
                    viewController?.showError(error)
                }
            }
        }
    }
}
