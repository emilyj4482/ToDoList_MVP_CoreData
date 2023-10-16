//
//  AddListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class AddListViewController: UIViewController {
    
    private lazy var presenter = AddListPresenter(viewController: self)
    
    // 구성 : bar button cancel, done, textfield
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension AddListViewController: AddListProtocol {
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let superview = view.safeAreaLayoutGuide
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
            textField.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            textField.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset)
        ])
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

private extension AddListViewController {
    @objc func leftBarButtonTapped() {
        presenter.leftBarButtonTapped()
    }
    
    @objc func rightBarButtonTapped() {
        presenter.rightBarButtonTapped()
    }
}
