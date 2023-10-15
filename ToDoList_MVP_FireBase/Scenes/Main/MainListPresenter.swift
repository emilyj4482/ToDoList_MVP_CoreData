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
}

final class MainListPresenter: NSObject {
    private let viewController: MainListProtocol
    
    init(viewController: MainListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
        viewController.setupViews()
    }
    
    func addListButtonTapped() {
        print("button tapped")
    }
}

extension MainListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        cell.setup()
        
        return cell
    }
    
    
}

extension MainListPresenter: UICollectionViewDelegate {
    
}
