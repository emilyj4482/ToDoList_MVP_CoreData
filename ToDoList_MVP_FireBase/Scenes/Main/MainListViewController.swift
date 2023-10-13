//
//  ViewController.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

final class MainListViewController: UIViewController {
    
    private lazy var presenter = MainListPresenter(viewController: self)

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
}
