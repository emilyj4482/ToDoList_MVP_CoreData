//
//  AddListViewController.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/19.

import UIKit

class AddListViewController: UIViewController, AddListProtocol {
    
    private lazy var presenter = AddListPresenter(viewController: self, repository: repository)
    private var repository: TodoRepository
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        barButtonItem.tintColor = .mainTintColor
        return barButtonItem
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        barButtonItem.tintColor = .mainTintColor
        return barButtonItem
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Untitled list"
        textField.font = .systemFont(ofSize: 35.0, weight: .bold)
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    init(repository: TodoRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    @objc private func leftBarButtonTapped() {
        
    }
    
    @objc private func rightBarButtonTapped() {
        
    }
}
