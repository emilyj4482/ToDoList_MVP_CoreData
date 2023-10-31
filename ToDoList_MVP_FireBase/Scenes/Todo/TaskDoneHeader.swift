//
//  TaskDoneHeader.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 10/31/23.
//

import UIKit

final class TaskDoneHeader: UITableViewHeaderFooterView {
    
    static let identifier = "TaskDoneHeader"
    
    private lazy var doneLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .light)
        label.textColor = .mainTintColor
        
        return label
    }()
    
    func layout() {
        addSubview(doneLabel)
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        doneLabel.text = "tasks done!"
        doneLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16.0).isActive = true
        doneLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}
