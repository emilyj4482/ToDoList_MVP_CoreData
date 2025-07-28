//
//  TaskDoneHeader.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/31.
//  Refactored by EMILY on 2025/07/22.

import UIKit
import CoreData

class TaskDoneHeader: UITableViewHeaderFooterView {
    static let identifier = String(describing: TaskDoneHeader.self)
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .light)
        label.textColor = .mainTintColor
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        addSubviews([headerLabel])
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: NSFetchedResultsSectionInfo) {
        let isDoneSection = section.name == "1"
        
        if isDoneSection {
            headerLabel.text = "tasks done!"
        } else {
            headerLabel.text = ""
        }
    }
}
