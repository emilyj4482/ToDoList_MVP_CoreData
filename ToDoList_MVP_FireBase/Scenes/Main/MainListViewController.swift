//
//  ViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit
import Firebase

final class MainListViewController: UIViewController {
    
    let tm = TodoManager.shared
    let db = Database.database().reference()
    
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
    
    func layout() {
        
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
    
    func fetchData() {
        db.getData { error, snapshot in
            guard
                let snapshot = snapshot,
                snapshot.exists()
            else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
                    let decoder = JSONDecoder()
                    let array: [List] = try decoder.decode([List].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.tm.lists = array
                        self.reload()
                    }
                    
                    let lastId = array.last?.id
                    self.tm.lastListId = lastId ?? 1
                } catch {
                    print("ERROR >>> \(error)")
                }
        }
    }
    
    func goToTodoListView(index: Int) {
        tm.list = tm.lists[index]
        navigationController?.pushViewController(TodoListViewController(), animated: true)
    }
    
    func observeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.reloadMainView, object: nil)
    }
}

private extension MainListViewController {
    @objc func addListButtonTapped() {
        let vc = UINavigationController(rootViewController: AddListViewController())
        present(vc, animated: true)
    }
    
    @objc func reload() {
        collectionView.reloadData()
    }
}
