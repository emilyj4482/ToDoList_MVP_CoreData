//
//  TodoListView.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/22.
//

import UIKit

protocol TodoListViewDelegate: AnyObject {
    func addTaskButtonTapped()
}

class TodoListView: UIView {
    
    weak var delegate: TodoListViewDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.rowHeight = 50
        tableView.separatorStyle = .singleLine
        tableView.contentInsetAdjustmentBehavior = .never   // prevent scrolling down as soon as vc pushed
        tableView.sectionHeaderHeight = 0                   // set default for unwanted headers
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.register(TaskDoneHeader.self, forHeaderFooterViewReuseIdentifier: TaskDoneHeader.identifier)
        
        return tableView
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setTitle(" Add a Task", for: .normal)
        button.tintColor = .mainTintColor
        button.setTitleColor(.mainTintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(
        delegate: TodoListViewDelegate,
        tableViewDataSource: UITableViewDataSource,
        tableViewDelegate: UITableViewDelegate
    ) {
        self.delegate = delegate
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
    }
    
    private func setupUI() {
        addSubviews([
            tableView,
            addTaskButton
        ])
        
        let offset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
            addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
    }
    
    func hideAddTaskButton(if isImportantList: Bool) {
        addTaskButton.isHidden = isImportantList
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func tableViewBeginUpdates() {
        tableView.beginUpdates()
    }
    
    func tableViewEndUpdates() {
        tableView.endUpdates()
    }
    
    func tableViewInsertRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .fade)
    }
    
    func tableViewReloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func tableViewDeleteRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func tableViewInsertSections(_ sections: IndexSet) {
        tableView.insertSections(sections, with: .fade)
    }
    
    func tableViewDeleteSections(_ sections: IndexSet) {
        tableView.deleteSections(sections, with: .fade)
    }
    
    @objc private func addTaskButtonTapped() {
        delegate?.addTaskButtonTapped()
    }
}
