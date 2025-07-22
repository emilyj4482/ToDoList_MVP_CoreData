//
//  TodoListViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit

class TodoListViewController: UIViewController {
    
    private lazy var presenter = TodoListPresenter(viewController: self, repository: repository, list: list)
    private let containerView = TodoListView()
    private var repository: TodoRepository
    
    let list: ListEntity
    
    private lazy var rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    
    init(repository: TodoRepository, list: ListEntity) {
        self.repository = repository
        self.list = list
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

extension TodoListViewController: TodoListViewDelegate {
    func addTaskButtonTapped() {
        presenter.addTaskButtonTapped()
    }
}

extension TodoListViewController: TodoListProtocol {
    func setupNavigationBar() {
        navigationItem.title = list.name
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
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
    
    func hideButtonsIfNeeded() {
        let isHidden = list.orderIndex == 0
        containerView.hideAddTaskButton(if: isHidden)
        rightBarButtonItem.isHidden = isHidden
    }
    
    @objc private func rightBarButtonTapped() {
        presenter.rightBarButtonTapped()
    }
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        
        return cell
    }
}
