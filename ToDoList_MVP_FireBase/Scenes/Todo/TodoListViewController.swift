//
//  TodoListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    let tm = TodoManager.shared
    
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
        navigationItem.title = tm.list?.name
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
        // textfield를 가진 alert 창을 띄워 list 이름 수정 기능 제공
        let editAlert = UIAlertController(title: "Type your new list name down below.", message: "", preferredStyle: .alert)
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let btnDone = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            guard let text = editAlert.textFields?[0].text?.trim() else { return }
            
            if !text.isEmpty {
                tm.updateList(text)
                // view title 및 main view reload
                navigationItem.title = text
                NotificationCenter.default.post(name: Notification.reloadMainView, object: nil)
            }
        }
        
        editAlert.addTextField { tf in
            tf.placeholder = self.tm.list?.name ?? ""
        }
        editAlert.addAction(btnCancel)
        editAlert.addAction(btnDone)
        
        present(editAlert, animated: true)
    }
    
    @objc func addTaskButtonTapped() {
        print("add btn tapped")
    }
}
