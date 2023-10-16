//
//  TaskCell.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class TaskCell: UICollectionViewCell {
    static let identifier = "TaskCell"
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.tintColor = button.isSelected ? .green : .red
        
        return button
    }()
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "to study"
        
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .yellow
        
        return button
    }()
    
    func setup() {
        [doneButton, taskTitleLabel, starButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        guard let superview = taskTitleLabel.superview else { return }
        
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            
            taskTitleLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            taskTitleLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 10.0),
            
            starButton.centerYAnchor.constraint(equalTo: taskTitleLabel.centerYAnchor),
            starButton.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
