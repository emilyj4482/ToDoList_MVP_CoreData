//
//  Extension+String.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 20/07/2025.
//

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
