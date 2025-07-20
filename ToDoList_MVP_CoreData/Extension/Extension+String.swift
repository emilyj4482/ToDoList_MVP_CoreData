//
//  Extension+String.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/20.
//

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
