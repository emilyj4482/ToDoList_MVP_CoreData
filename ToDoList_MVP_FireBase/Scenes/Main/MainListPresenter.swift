//
//  MainListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

protocol MainListProtocol {
    func setupNavigationBar()
    func layout()
    func fetchData()
    func goToTodoListView(index: Int)
    func observeNotification()
}

final class MainListPresenter: NSObject {
    let viewController: MainListProtocol
    let tm = TodoManager.shared
    
    init(viewController: MainListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
        viewController.layout()
        viewController.fetchData()
        viewController.observeNotification()
    }
}

extension MainListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tm.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        
        let list = tm.lists[indexPath.row]
        cell.configure(list: list, superview: cell)
        
        return cell
    }
    
    
}

extension MainListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController.goToTodoListView(index: indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, completion in
            
            // list가 important task를 포함하고 있을 때, list에 속했던 important task가 Important list에서도 삭제
            let list = tm.lists[indexPath.row]
            guard let tasks = list.tasks else { return }
            if tasks.contains(where: { $0.isImportant }) {
                tm.lists[0].tasks?.removeAll(where: { $0.listId == list.id })
            }
            self.tm.deleteList(index: indexPath.row)
            completion(true)
            tableView.reloadData()
        }
        
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
}
