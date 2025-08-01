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
    
    private let textField: UITextField = {
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
        presenter.viewDidLoad()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubviews([textField])
        
        let superview = view.safeAreaLayoutGuide
        let offset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset),
            textField.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset),
            textField.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset)
        ])
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Reserved Name",
            message: "\"Important\" cannot be used. Please choose a different one.",
            preferredStyle: .alert
        )
        
        let okayButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
    
    @objc private func leftBarButtonTapped() {
        presenter.leftBarButtonTapped()
    }
    
    @objc private func rightBarButtonTapped() {
        if let input = textField.text {
            presenter.rightBarButtonTapped(input)
        }
    }
}
