//
//  AddListPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

protocol AddListProtocol {
    
}

final class AddListPresenter: NSObject {
    private let viewController: AddListProtocol
    
    init(viewController: AddListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        
    }
}
