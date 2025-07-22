//
//  TodoListViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit

class TodoListViewController: UIViewController {
    
    private lazy var presenter = TodoListPresenter(viewController: self, repository: repository)
    private var repository: TodoRepository
    
    let list: ListEntity
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension TodoListViewController: TodoListProtocol {
    func setupNavigationBar() {
        navigationItem.title = list.name
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}
