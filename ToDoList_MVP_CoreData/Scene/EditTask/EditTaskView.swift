//
//  EditTaskView.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/23.
//

import UIKit

protocol EditTaskViewDelegate: AnyObject {
    func doneButtonTapped(with text: String)
}

class EditTaskView: UIView {
    
    weak var delegate: EditTaskViewDelegate?
    
    private let checkImage = UIImageView()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.becomeFirstResponder()
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.mainTintColor, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inject(delegate: EditTaskViewDelegate) {
        self.delegate = delegate
    }
    
    private func setupUI() {
        addSubviews([
            checkImage,
            textField,
            doneButton
        ])
        
        let offset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            checkImage.widthAnchor.constraint(equalToConstant: 20.0),
            checkImage.heightAnchor.constraint(equalToConstant: 20.0),
            
            checkImage.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            checkImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            
            textField.centerYAnchor.constraint(equalTo: checkImage.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: checkImage.trailingAnchor, constant: 10.0),
            textField.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -5.0),
            
            doneButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 45.0),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
        ])
    }
    
    func configure() {
        checkImage.image = UIImage(systemName: "circle")
        checkImage.tintColor = .red
    }
    
    @objc private func doneButtonTapped() {
        if let text = textField.text?.trim, !text.isEmpty {
            delegate?.doneButtonTapped(with: text)
        }
    }
}
