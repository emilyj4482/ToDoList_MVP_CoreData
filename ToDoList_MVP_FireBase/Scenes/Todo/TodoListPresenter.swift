//
//  TodoListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

protocol TodoListProtocol {
    func setupNavigationBar()
    func layout()
    func observeNotification()
}

final class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    let tm = TodoManager.shared
    
    init(viewController: TodoListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
        viewController.layout()
        viewController.observeNotification()
    }
    
    func viewWillDisappear() {
        // 빈 list에 들어갈 때 task가 있었던 list의 view가 그대로 남는 현상 방지 : view와 연결된 프로퍼티 초기화
        tm.tasks = []
    }
}

extension TodoListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tm.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }

        var task = tm.tasks[indexPath.item]
        cell.configure(task: task, superview: cell)
        
        // handler : done & star button tap에 따른 data update
        cell.doneButtonTapHandler = { isDone in
            task.isDone = isDone
            self.tm.updateTask(task)
        }
        
        cell.starButtonTapHandler = { isImportant in
            task.isImportant = isImportant
            self.tm.updateImportant(task)
        }
        
        return cell
    }
}

extension TodoListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            print("delete tapped")
        }
        
        let edit = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("edit tapped")
        }
        
        delete.image = UIImage(systemName: "trash")
        edit.image = UIImage(systemName: "pencil")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipe
    }
}
