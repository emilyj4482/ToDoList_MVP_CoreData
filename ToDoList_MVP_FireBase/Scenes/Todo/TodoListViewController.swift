//
//  TodoListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    private lazy var presenter = TodoListPresenter(viewController: self)
    
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
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.identifier)
        
        return collectionView
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        return barButtonItem
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle(" Add a Task", for: .normal)
        button.tintColor = .mainTintColor
        button.setTitleColor(.mainTintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension TodoListViewController: TodoListProtocol {
    func setTitle() {
        navigationItem.title = "Untitled list"
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .mainTintColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        [collectionView, addTaskButton]
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
            
            addTaskButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: inset),
            addTaskButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: inset),
            addTaskButton.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
        ])
    }
}

private extension TodoListViewController {
    @objc func rightBarButtonTapped() {
        print("edit btn tapped")
    }
    
    @objc func addTaskButtonTapped() {
        print("add btn tapped")
    }
}
