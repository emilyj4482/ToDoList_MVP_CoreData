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
    // func reload()
    func goToTodoListView()
    func fetchData()
    func getLists() -> [List]
}

final class MainListPresenter: NSObject {
    let viewController: MainListProtocol
    
    init(viewController: MainListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
        viewController.setupViews()
        viewController.fetchData()
    }
}

extension MainListPresenter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewController.getLists().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        let list = viewController.getLists()[indexPath.item]
        cell.configure(list: list, superview: cell)
        // cell.layout()
        
        return cell
    }
}

extension MainListPresenter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController.goToTodoListView()
    }
}
