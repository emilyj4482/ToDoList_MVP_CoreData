//
//  EditTaskViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/22.
//  Refactored by EMILY on 2025/07/23.

import UIKit

class EditTaskViewController: UIViewController, EditTaskProtocol {
    
    private lazy var presenter = EditTaskPresenter(viewController: self, repository: repository)
    private var repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        sheetPresentationController?.detents = [.custom(resolver: { _ in return 50 })]
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
