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
        
        label.text = "to study"
        
        return label
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "10"
        label.font = .systemFont(ofSize: 10.0, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    func setup() {
        backgroundColor = .systemBackground
        
        [listIcon, listNameLabel, taskCountLabel]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
                
        guard let superview = listNameLabel.superview else { return }
        
        NSLayoutConstraint.activate([
            listIcon.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            
            listNameLabel.leadingAnchor.constraint(equalTo: listIcon.trailingAnchor, constant: 10.0),
            
            taskCountLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -5.0)
        ])
    }
}
