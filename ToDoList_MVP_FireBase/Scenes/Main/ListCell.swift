//
//  ListCell.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 14/10/2023.
//

import UIKit

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    private lazy var listIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "checklist.checked")
        imageView.tintColor = .label
        
        return imageView
    }()
    
    private lazy var listNameLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Untitled list"
        
        return label
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "10"
        label.font = .systemFont(ofSize: 10.0, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    private func layout(_ superview: UICollectionViewCell) {
    // func layout() {
        [listIcon, listNameLabel, taskCountLabel]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
                
        guard let superview = listNameLabel.superview else { return }
        
        NSLayoutConstraint.activate([
            listIcon.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            listIcon.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            
            listNameLabel.centerYAnchor.constraint(equalTo: listIcon.centerYAnchor),
            listNameLabel.leadingAnchor.constraint(equalTo: listIcon.trailingAnchor, constant: 10.0),
            
            taskCountLabel.centerYAnchor.constraint(equalTo: listNameLabel.centerYAnchor),
            taskCountLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -5.0)
        ])
    }
    
    func configure(list: List, superview cell: UICollectionViewCell) {
        layout(cell)
        
        listNameLabel.text = list.name
        taskCountLabel.text = "\(list.tasks.count)"
    }
}
