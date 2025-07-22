//
//  MainListViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/18.

import UIKit

class MainListViewController: UIViewController {
    
    private lazy var presenter = MainListPresenter(viewController: self, repository: repository)
    private let containerView = MainListView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension MainListViewController: MainListViewDelegate {
    func addListButtonTapped() {
        presenter.addListButtonTapped()
    }
}

extension MainListViewController: MainListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "ToDoList"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    func presentAddListViewController() {
        let addListViewController = UINavigationController(rootViewController: AddListViewController(repository: repository))
        present(addListViewController, animated: true)
    }
    
    func pushToTodoListViewController(with list: ListEntity) {
        let viewController = TodoListViewController(repository: repository, list: list)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func reloadData() {
        containerView.reloadData()
    }
    
    func showError(_ error: Error) {
        print("[Error] \(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "Error",
            message: "Data could not be loaded. Please try again later.",
            preferredStyle: .alert
        )
        
        let okayButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
    
    func showActionSheet(indexPath: IndexPath) {
        let actionSheet = UIAlertController(
            title: "Delete List",
            message: "Are you sure you want to delete this list?",
            preferredStyle: .actionSheet)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            Task {
                await self?.presenter.deleteList(at: indexPath)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(yesButton)
        actionSheet.addAction(cancelButton)
        present(actionSheet, animated: true)
    }
    
    func tableViewBeginUpdates() {
        containerView.tableViewBeginUpdates()
    }
    
    func tableViewEndUpdates() {
        containerView.tableViewEndUpdates()
    }
    
    func tableViewInsertRows(at indexPaths: [IndexPath]) {
        containerView.tableViewInsertRows(at: indexPaths)
    }
    
    func tableViewReloadRows(at indexPaths: [IndexPath]) {
        containerView.tableViewReloadRows(at: indexPaths)
    }
    
    func tableViewDeleteRows(at indexPaths: [IndexPath]) {
        containerView.tableViewDeleteRows(at: indexPaths)
    }
}

extension MainListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        
        let list = presenter.object(at: indexPath)
        cell.configure(list: list)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Important list는 삭제 방지
        guard indexPath.row != 0 else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            
            self?.presenter.showActionSheet(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
    }
}
