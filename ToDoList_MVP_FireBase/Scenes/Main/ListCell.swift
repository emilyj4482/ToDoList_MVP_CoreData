//
//  ListCell.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 14/10/2023.
//

import UIKit

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    private lazy var listNameLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "test text"
        
        return label
    }()
    
    func setup() {
        backgroundColor = .systemBackground
        
        addSubview(listNameLabel)
        listNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = listNameLabel.superview else { return }
        
        NSLayoutConstraint.activate([
            listNameLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 10.0)
        ])
    }
}
