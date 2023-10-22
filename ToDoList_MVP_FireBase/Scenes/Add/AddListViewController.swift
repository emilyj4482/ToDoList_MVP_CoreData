//
//  AddListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class AddListViewController: UIViewController {
    
    let tm = TodoManager.shared
    
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
    func layout() {
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
    
    func postNotification() {
        NotificationCenter.default.post(name: Notification.reloadMainView, object: nil)
    }
    
    // list name 중복검사
    private func examListName(_ text: String) -> String {
        let list = tm.lists.map { list in
            list.name
        }
        
        var count = 1
        var listName = text
        while list.contains(listName) {
            listName = "\(text) (\(count))"
            count += 1
        }
        
        return listName
    }
    
    func addList() {
        guard var newListName = textField.text?.trim() else { return }
        if newListName.isEmpty {
            newListName = "Untitled list"
        }
        tm.addList(examListName(newListName))
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
