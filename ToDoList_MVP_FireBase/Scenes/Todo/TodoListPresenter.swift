//
//  TodoListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

protocol TodoListProtocol {
    func setTitle()
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
        viewController.setTitle()
        viewController.layout()
        viewController.observeNotification()
    }
}

extension TodoListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tm.list?.tasks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell,
            let task = tm.list?.tasks?[indexPath.item]
        else { return UICollectionViewCell() }
        
        cell.configure(task: task, superview: cell)
        
        return cell
    }
}

extension TodoListPresenter: UICollectionViewDelegate {
    
}
