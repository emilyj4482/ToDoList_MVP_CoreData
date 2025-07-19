//
//  MainListViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/18.

import UIKit

class MainListViewController: UIViewController {
    
    private lazy var presenter = MainListPresenter(viewController: self, todoManager: todoManager)
    private let containerView = MainListView()
    private var todoManager: TodoManager
    
    init(todoManager: TodoManager) {
        self.todoManager = todoManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension MainListViewController: MainListViewDelegate {
    func addListButtonTapped() {
        presenter.addListButtonTapped()
    }
}

extension MainListViewController: MainListProtocol {
    func setupUI() {
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
    
    func setupContainerView() {
        containerView.inject(delegate: self, tableViewDataSource: self, tableViewDelegate: self)
    }
    
    func presentAddListViewController() {
        let addListViewController = AddListViewController(todoManager: todoManager)
        present(addListViewController, animated: true)
    }
}

extension MainListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

#Preview {
    MainListViewController(todoManager: TodoManager())
}
