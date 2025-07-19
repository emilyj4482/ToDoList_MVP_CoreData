//
//  MainListView.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/18.
//

import UIKit

protocol MainListViewDelegate: AnyObject {
    func addListButtonTapped()
}

class MainListView: UIView {
    
    weak var delegate: MainListViewDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        
        return tableView
    }()
    
    private let countLabel: UILabel = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(
        delegate: MainListViewDelegate,
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
            countLabel,
            addListButton
        ])
        
        let offset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            addListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            addListButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
            
            countLabel.leadingAnchor.constraint(equalTo: addListButton.leadingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: addListButton.topAnchor, constant: -offset),
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -offset)
        ])
    }
    
    @objc private func addListButtonTapped() {
        delegate?.addListButtonTapped()
    }
}
