//
//  ListCell.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/19.

import UIKit

final class ListCell: UITableViewCell {
    static let identifier = String(describing: ListCell.self)
    
    private let listIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        return imageView
    }()
    
    private let listNameLabel = UILabel()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 10.0, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubviews([
            listIcon,
            listNameLabel,
            taskCountLabel
        ])
        
        let offset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            listIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            listIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            
            listNameLabel.centerYAnchor.constraint(equalTo: listIcon.centerYAnchor),
            listNameLabel.leadingAnchor.constraint(equalTo: listIcon.trailingAnchor, constant: 10.0),
            
            taskCountLabel.centerYAnchor.constraint(equalTo: listNameLabel.centerYAnchor),
            taskCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
    }
    
    func configure(with list: ListEntity) {
        setupUI()

        // Important list의 경우 icon을 star로 지정
        if list.orderIndex == 0 {
            listIcon.image = UIImage(systemName: "star.fill")
        } else {
            listIcon.image = UIImage(systemName: "checklist.checked")
        }
        
        listNameLabel.text = list.name
        taskCountLabel.text = "\(list.tasks?.count ?? 0)"
    }
}
