//
//  TodoListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

protocol TodoListProtocol {
    func setTitle()
    func setupViews()
}

final class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    let tm = TodoManager.shared
    
    init(viewController: TodoListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setTitle()
        viewController.setupViews()
    }
}

extension TodoListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // temporarily return 1
        return tm.list?.tasks?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UICollectionViewCell() }
        
        // temporary data
        let task = Task(listId: 2, title: "to study", isDone: true, isImportant: false)
        
        cell.configure(task: task, superview: cell)
        
        return cell
    }
}

extension TodoListPresenter: UICollectionViewDelegate {
    
}
