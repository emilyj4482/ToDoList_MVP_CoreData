//
//  Extension+UIView.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 18/07/2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
