//
//  TodoListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    private lazy var presenter = TodoListPresenter(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension TodoListViewController: TodoListProtocol {
    
}
