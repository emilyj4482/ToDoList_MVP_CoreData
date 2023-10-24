//
//  TaskCell.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 16/10/2023.
//

import UIKit

final class TaskCell: UICollectionViewCell {
    
    static let identifier = "TaskCell"
    
    // data update : handler를 통해 bool 값 전송하여 presenter에서 처리
    var doneButtonTapHandler: ((Bool) -> Void)?
    var starButtonTapHandler: ((Bool) -> Void)?
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private func layout(_ superview: UICollectionViewCell) {
        [doneButton, taskTitleLabel, starButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            
            taskTitleLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            taskTitleLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 10.0),
            
            starButton.centerYAnchor.constraint(equalTo: taskTitleLabel.centerYAnchor),
            starButton.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    func configure(task: Task, superview cell: UICollectionViewCell) {
        layout(cell)
        
        taskTitleLabel.text = task.title
        doneButton.isSelected = task.isDone ? true : false
        doneButton.tintColor = doneButton.isSelected ? .green : .red
        starButton.isSelected = task.isImportant ? true : false
        
        strikethrough(isDone: task.isDone)
    }
    
    // isDone 상태에 따라 task title label 취소선, 흐리게 처리
    private func strikethrough(isDone: Bool) {
        if isDone {
            taskTitleLabel.attributedText = NSAttributedString(string: taskTitleLabel.text!, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            taskTitleLabel.alpha = 0.5
        } else {
            taskTitleLabel.attributedText = NSAttributedString(string: taskTitleLabel.text!, attributes: [.strikethroughStyle: NSUnderlineStyle()])
            taskTitleLabel.alpha = 1
        }
    }
}

private extension TaskCell {
    @objc func doneButtonTapped() {
        doneButton.isSelected.toggle()
        doneButton.tintColor = doneButton.isSelected ? .green : .red
        strikethrough(isDone: doneButton.isSelected)
        doneButtonTapHandler?(doneButton.isSelected)
    }
    
    @objc func starButtonTapped() {
        starButton.isSelected.toggle()
        starButtonTapHandler?(starButton.isSelected)
        // main에서 important list count label update
        NotificationCenter.default.post(name: Notification.reloadMainView, object: nil)
        // important list에서 task 제거 시 view reload
        NotificationCenter.default.post(name: Notification.reloadTodoView, object: nil)
    }
}
