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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("swiped")
        }
    }
}
