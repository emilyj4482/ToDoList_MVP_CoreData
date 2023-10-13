//
//  ViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

final class MainListViewController: UIViewController {
    
    private lazy var presenter = MainListPresenter(viewController: self)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // data source
        collectionView.dataSource = presenter
        
        // delegate
        collectionView.delegate = presenter
        
        // cell
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension MainListViewController: MainListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "ToDoList"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let superview = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: superview.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
