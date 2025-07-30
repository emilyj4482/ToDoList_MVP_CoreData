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
    
    private var list: ListEntity
    
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
    
    @objc private func rightBarButtonTapped() {
        presenter.rightBarButtonTapped()
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
    
    func presentEditTaskViewController(with mode: EditTaskMode) {
        var viewController: UIViewController
        
        switch mode {
        case .create(let listID):
            viewController = EditTaskViewController(repository: repository, mode: .create(listID: listID))
        case .retitle(let task):
            viewController = EditTaskViewController(repository: repository, mode: .retitle(task: task))
        }
        present(viewController, animated: true)
    }
    
    func reloadData() {
        containerView.reloadData()
    }
    
    func reloadList(from list: ListEntity) {
        self.list = list
        navigationItem.title = list.name
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
    
    func showTextFieldAlert() {
        let alert = UIAlertController(
            title: "Type a new name for the list.",
            message: "",
            preferredStyle: .alert
        )
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let doneButton = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text?.trim else { return }
            if !text.isEmpty {
                Task {
                    await self?.presenter.renameList(with: text)
                    self?.presenter.reloadListEntity()
                }
            }
        }
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = self?.list.name
        }
        alert.addAction(cancelButton)
        alert.addAction(doneButton)
        
        present(alert, animated: true)
    }
    
    func showActionSheet(indexPath: IndexPath) {
        let actionSheet = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            preferredStyle: .actionSheet
        )
        
        let yesButton = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            Task {
                await self?.presenter.deleteTask(at: indexPath)
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
    
    func tableViewInsertSections(_ sections: IndexSet) {
        containerView.tableViewInsertSections(sections)
    }
    
    func tableViewDeleteSections(_ sections: IndexSet) {
        containerView.tableViewDeleteSections(sections)
    }
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        
        let task = presenter.object(at: indexPath)
        cell.configure(with: task)
        
        cell.checkButtonTapHandler = { [weak self] isDone in
            print(isDone)
            Task {
                try await self?.presenter.toggleTaskDone(isDone, taskID: task.objectID)
            }
        }
        
        cell.starButtonTapHandler = { [weak self] isImportant in
            print(isImportant)
            Task {
                try await self?.presenter.toggleTaskImportant(isImportant, taskID: task.objectID)
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard
            let sections = presenter.sectionsInfo(),
            section < sections.count
        else { return 0 }
        
        let section = sections[section]
        let isDoneSection = section.name == "1"
        
        return isDoneSection ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskDoneHeader.identifier) as? TaskDoneHeader,
            let sections = presenter.sectionsInfo()
        else { return nil }
        
        let section = sections[section]
        
        header.configure(with: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            
            self?.presenter.showActionSheet(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            
            self?.presenter.editSwipeActionTapped(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        editAction.image = UIImage(systemName: "pencil")
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipe
    }
}
