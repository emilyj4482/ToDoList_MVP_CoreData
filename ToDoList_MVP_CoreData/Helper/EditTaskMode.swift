//
//  EditTaskMode.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2025/07/31.
//

import Foundation
import CoreData

enum EditTaskMode {
    case create(listID: UUID)
    case retitle(task: TaskEntity)
}
