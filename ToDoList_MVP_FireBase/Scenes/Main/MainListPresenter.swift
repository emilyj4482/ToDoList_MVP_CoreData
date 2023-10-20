//
//  MainListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

protocol MainListProtocol {
    func setupNavigationBar()
    func setupViews()
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
        viewController.setupViews()
        viewController.fetchData()
        viewController.observeNotification()
    }
}

extension MainListPresenter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tm.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        let list = tm.lists[indexPath.item]
        cell.configure(list: list, superview: cell)
        
        return cell
    }
}

extension MainListPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.goToTodoListView(index: indexPath.item)
    }
}
