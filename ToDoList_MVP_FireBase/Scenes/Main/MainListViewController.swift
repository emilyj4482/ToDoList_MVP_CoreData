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
        
        // layout
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16.0
        
        layout.estimatedItemSize = CGSize(width: view.frame.width - (inset * 2), height: 40.0)
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // data source
        collectionView.dataSource = presenter
        
        // delegate
        collectionView.delegate = presenter
        
        // cell
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        
        return collectionView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        
        label.text = "You have 0 custom list."
        label.textColor = .mainTintColor
        label.font = .systemFont(ofSize: 14.0)
        
        return label
    }()
    
    private lazy var addListButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle(" New List", for: .normal)
        button.tintColor = .mainTintColor
        button.setTitleColor(.mainTintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        
        return button
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
    
    func setupViews() {
        
        [collectionView, countLabel, addListButton]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        let superview = view.safeAreaLayoutGuide
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: superview.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            countLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: inset),
            
            addListButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: inset),
            addListButton.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            addListButton.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
        ])
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func goToTodoListView() {
        navigationController?.pushViewController(TodoListViewController(), animated: true)
    }
}

private extension MainListViewController {
    @objc func addListButtonTapped() {
        let vc = UINavigationController(rootViewController: AddListViewController())
        present(vc, animated: true)
    }
}
