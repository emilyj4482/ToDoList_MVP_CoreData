//
//  AddListViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class AddListViewController: UIViewController {
    
    private lazy var presenter = AddListPresenter(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension AddListViewController: AddListProtocol {
    
}
