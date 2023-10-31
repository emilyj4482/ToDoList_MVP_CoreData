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
    func swipedToEdit(_ task: Task)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tm.tasks.filter({ $0.isDone }).isEmpty {
        case false:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return tm.tasks.filter({ $0.isDone }).count
        default:
            return tm.tasks.filter({ !$0.isDone }).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
        var task: Task
        
        switch indexPath.section {
        case 1:
            task = tm.tasks.filter({ $0.isDone })[indexPath.item]
        default:
            task = tm.tasks.filter({ !$0.isDone })[indexPath.item]
        }
        
        // var task = tm.tasks[indexPath.item]
        cell.configure(task: task, superview: cell)
        
        // handler : done & star button tap에 따른 data update
        cell.doneButtonTapHandler = { isDone in
            task.isDone = isDone
            self.tm.updateTask(task)
            tableView.reloadData()
        }
        
        cell.starButtonTapHandler = { isImportant in
            task.isImportant = isImportant
            self.tm.updateImportant(task)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskDoneHeader.identifier) as? TaskDoneHeader else { return UIView() }
        header.layout()
        
        switch section {
        case 1:
            return header
        default:
            return UIView()
        }
    }
    
}

extension TodoListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var task: Task
        switch indexPath.section {
        case 1:
            task = tm.tasks.filter({ $0.isDone })[indexPath.row]
        default:
            task = tm.tasks.filter({ !$0.isDone })[indexPath.row]
        }
        
        let delete = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, completion in
            self.tm.deleteTask(task)
            completion(true)
            // view reload : task count 적용을 위해 main view도 reload
            tableView.reloadData()
            NotificationCenter.default.post(name: Notification.reloadMainView, object: nil)
        }
        
        let edit = UIContextualAction(style: .normal, title: "") { [unowned self] _, _, completion in
            viewController.swipedToEdit(task)
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        edit.image = UIImage(systemName: "pencil")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipe
    }
    
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 20
        default:
            return 0
        }
    }
}
