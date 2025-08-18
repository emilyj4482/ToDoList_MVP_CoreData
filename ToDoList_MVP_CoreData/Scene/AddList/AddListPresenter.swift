//
//  AddListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/19.

import Foundation

protocol AddListProtocol: AnyObject {
    func setupUI()
    func dismiss()
    func showAlert()
}

final class AddListPresenter: NSObject {
    private weak var viewController: AddListProtocol?
    private let repository: TodoRepository
    
    init(viewController: AddListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController?.setupUI()
    }
    
    func leftBarButtonTapped() {
        viewController?.dismiss()
    }
    
    func rightBarButtonTapped(_ input: String) {
        if input.trim == "Important" {
            viewController?.showAlert()
        } else {
            Task {
                try await repository.createList(name: input)
                await MainActor.run {
                    viewController?.dismiss()
                }
            }
        }
    }
}
