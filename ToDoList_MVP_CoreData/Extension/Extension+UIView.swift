//
//  Extension+UIView.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/18.
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
