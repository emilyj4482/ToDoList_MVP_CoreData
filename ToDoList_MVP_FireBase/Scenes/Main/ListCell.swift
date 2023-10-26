//
//  ListCell.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 14/10/2023.
//

import UIKit

final class ListCell: UITableViewCell {
    static let identifier = "ListCell"
    
    private lazy var listIcon: UIImageView = {
        let imageView = UIImageView()

        imageView.tintColor = .label
        
        return imageView
    }()
    
    private lazy var listNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 10.0, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    private func layout(_ superview: UITableViewCell) {
        [listIcon, listNameLabel, taskCountLabel]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            listIcon.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            listIcon.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            
            listNameLabel.centerYAnchor.constraint(equalTo: listIcon.centerYAnchor),
            listNameLabel.leadingAnchor.constraint(equalTo: listIcon.trailingAnchor, constant: 10.0),
            
            taskCountLabel.centerYAnchor.constraint(equalTo: listNameLabel.centerYAnchor),
            taskCountLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -5.0)
        ])
    }
    
    func configure(list: List, superview cell: UITableViewCell) {
        layout(cell)
        
        // cell tap 시 배경색 회색되지 않게
        cell.selectionStyle = .none
        
        // Important list의 경우 icon을 star로 지정
        if list.id == 1 {
            listIcon.image = UIImage(systemName: "star.fill")
        } else {
            listIcon.image = UIImage(systemName: "checklist.checked")
        }
        
        listNameLabel.text = list.name
        taskCountLabel.text = "\(list.tasks?.count ?? 0)"
    }
}
