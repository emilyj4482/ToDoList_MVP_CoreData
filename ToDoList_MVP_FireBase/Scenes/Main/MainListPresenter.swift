//
//  MainListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

protocol MainListProtocol {
    func setupNavigationBar()
}

final class MainListPresenter: NSObject {
    private let viewController: MainListProtocol
    
    init(viewController: MainListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
    }
}
