//
//  EditTaskViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/22.
//  Refactored by EMILY on 2025/07/23.

import UIKit

class EditTaskViewController: UIViewController, EditTaskProtocol {
    
    private lazy var presenter = EditTaskPresenter(viewController: self, repository: repository)
    private let containerView = EditTaskView()
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
        sheetPresentationController?.detents = [.custom(resolver: { _ in return 50 })]
        
        view.backgroundColor = .systemBackground
        view.addSubviews([containerView])
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func setupContainerView() {
        containerView.inject(delegate: self)
    }
}

extension EditTaskViewController: EditTaskViewDelegate {
    func doneButtonTapped(with text: String) {
        presenter.doneButtonTapped(with: text)
    }
}
