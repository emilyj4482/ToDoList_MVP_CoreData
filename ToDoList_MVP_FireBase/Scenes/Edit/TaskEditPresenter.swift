//
//  TaskEditPresenter.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 10/22/23.
//

import UIKit

protocol TaskEditProtocol {
    func configure()
    func setTask()
    func postNotification()
}

final class TaskEditPresenter: NSObject {
    private let viewController: TaskEditProtocol
    
    init(viewController: TaskEditProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController.configure()
    }
    
    func doneButtonTapped() {
        viewController.setTask()
        viewController.postNotification()
    }
}
