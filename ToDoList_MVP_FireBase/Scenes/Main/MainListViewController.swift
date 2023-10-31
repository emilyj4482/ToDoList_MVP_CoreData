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

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        // row 높이 지정
        tableView.rowHeight = 50
        
        // row 구분선 제거
        tableView.separatorStyle = .none
        
        // data source
        tableView.dataSource = presenter
        
        // delegate
        tableView.delegate = presenter
        
        // cell
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        
        return tableView
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
        
        [tableView, countLabel, addListButton]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        let superview = view.safeAreaLayoutGuide
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 5.0),
            tableView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            countLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            
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
    
    func showActionSheet(_ list: List, index: Int) {
        let alert = UIAlertController(title: "Are you sure deleting the list?", message: "", preferredStyle: .actionSheet)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteList(list, index: index)
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
    func deleteList(_ list: List, index: Int) {
        // 삭제 대상 list가 important task를 포함하고 있을 때, list에 속했던 important task들이 Important list에서도 삭제되어야 한다.
        guard let tasks = list.tasks else { return }
        if tasks.contains(where: { $0.isImportant }) {
            tm.lists[0].tasks?.removeAll(where: { $0.listId == list.id })
        }
        tm.deleteList(index: index)
    }
}

private extension MainListViewController {
    @objc func addListButtonTapped() {
        let vc = UINavigationController(rootViewController: AddListViewController())
        present(vc, animated: true)
    }
    
    @objc func reload() {
        tableView.reloadData()
    }
}
