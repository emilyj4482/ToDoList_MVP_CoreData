//
//  TodoListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/16.
//  Refactored by EMILY on 2025/07/22.

import UIKit
import CoreData

protocol TodoListProtocol {
    func setupNavigationBar()
    func setupUI()
    func setupContainerView()
    func hideButtonsIfNeeded()
    func presentEditTaskViewController()
    func reloadData()
    func reloadList(from list: ListEntity)
    func showError(_ error: Error)
    func showTextFieldAlert()
    func tableViewBeginUpdates()
    func tableViewEndUpdates()
    func tableViewInsertRows(at indexPaths: [IndexPath])
    func tableViewReloadRows(at indexPaths: [IndexPath])
    func tableViewDeleteRows(at indexPaths: [IndexPath])
    func tableViewInsertSections(_ sections: IndexSet)
    func tableViewDeleteSections(_ sections: IndexSet)
}

class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    private let repository: TodoRepository
    
    private var list: ListEntity
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let controller = NSFetchedResultsController(
            fetchRequest: list.name == "Important" ? repository.tasksFromImportantFetchRequest() : repository.tasksByDoneFetchRequest(for: list),
            managedObjectContext: repository.viewContext,
            sectionNameKeyPath: "isDone",   // this creates sections based on isDone property
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    }()
    
    init(
        viewController: TodoListProtocol,
        repository: TodoRepository,
        list: ListEntity
    ) {
        self.viewController = viewController
        self.repository = repository
        self.list = list
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupNavigationBar()
        viewController.setupContainerView()
        viewController.hideButtonsIfNeeded()
        loadTasks()
    }
    
    func rightBarButtonTapped() {
        viewController.showTextFieldAlert()
    }
    
    func addTaskButtonTapped() {
        viewController.presentEditTaskViewController()
    }
}

extension TodoListPresenter {
    func loadTasks() {
        do {
            try fetchedResultsController.performFetch()
            viewController.reloadData()
        } catch {
            viewController.showError(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 1 }
        
        return sections[section].numberOfObjects
    }
    
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func sectionsInfo() -> [NSFetchedResultsSectionInfo]? {
        return fetchedResultsController.sections
    }
    
    func object(at indexPath: IndexPath) -> TaskEntity {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func renameList(with name: String) async {
        do {
            try await repository.renameList(objectID: list.objectID, newName: name)
        } catch {
            viewController.showError(error)
        }
    }
    
    func reloadListEntity() {
        if let fetchedList = repository.fetchList(with: list.objectID) {
            self.list = fetchedList
            viewController.reloadList(from: fetchedList)
        }
    }
    
    func toggleTaskDone(_ isDone: Bool, taskID: NSManagedObjectID) async throws {
        try await repository.toggleTaskDone(objectID: taskID, isDone: isDone)
    }
    
    func toggleTaskImportant(_ isImportant: Bool, taskID: NSManagedObjectID) async throws {
        try await repository.toggleTaskImportant(objectID: taskID, isImportant: isImportant)
    }
}

extension TodoListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        viewController.tableViewBeginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                viewController.tableViewInsertRows(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                viewController.tableViewReloadRows(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                viewController.tableViewDeleteRows(at: [indexPath])
            }
        case .move:
            // handles moving between sections
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                viewController.tableViewDeleteRows(at: [indexPath])
                viewController.tableViewInsertRows(at: [newIndexPath])
            }
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange sectionInfo: any NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType
    ) {
        // this method handles changes to entire sections : when sections themselves are created or destoryed
        // >> this happens when the last item in a section is removed or the first item is added to a new section
        switch type {
        case .insert:
            viewController.tableViewInsertSections(IndexSet(integer: sectionIndex))
        case .delete:
            viewController.tableViewDeleteSections(IndexSet(integer: sectionIndex))
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        viewController.tableViewEndUpdates()
    }
}
