//
//  TaskCell.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit

class TaskCell: UITableViewCell {
    static let identifier = String(describing: TaskCell.self)
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var checkButtonTapHandler: ((Bool) -> Void)?
    
    private let taskTitleLabel = UILabel()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var starButtonTapHandler: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkButtonTapHandler = nil
        starButtonTapHandler = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubviews([
            checkButton,
            taskTitleLabel,
            starButton
        ])
        
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            taskTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskTitleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 10.0),
            
            starButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            starButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with task: TaskEntity) {
        taskTitleLabel.text = task.title
        checkButton.isSelected = task.isDone
        checkButton.tintColor = task.isDone ? .green : .red
        starButton.isSelected = task.isImportant
        strikeThroughText(if: task.isDone)
    }
    
    private func strikeThroughText(if isDone: Bool) {
        guard let text = taskTitleLabel.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = isDone ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [.strikethroughStyle: NSUnderlineStyle()]
        
        taskTitleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        taskTitleLabel.alpha = isDone ? 0.5 : 1.0
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        checkButton.tintColor = checkButton.isSelected ? .green : .red
        strikeThroughText(if: checkButton.isSelected)
        checkButtonTapHandler?(checkButton.isSelected)
    }
    
    @objc private func starButtonTapped() {
        starButton.isSelected.toggle()
        starButtonTapHandler?(starButton.isSelected)
    }
}
