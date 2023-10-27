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
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        
        return tableView
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
}

extension TodoListViewController: TodoListProtocol {
    func setupNavigationBar() {
        navigationItem.title = tm.list?.name
        navigationController?.navigationBar.tintColor = .mainTintColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func layout() {
        view.backgroundColor = .systemBackground
        
        [tableView, addTaskButton]
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
            
            addTaskButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: inset),
            addTaskButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: inset),
            addTaskButton.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
        ])
    }
    
    func observeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.reloadTodoView, object: nil)
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
        present(TaskEditViewController(), animated: true)
    }
    
    @objc func reload() {
        tableView.reloadData()
    }
}
