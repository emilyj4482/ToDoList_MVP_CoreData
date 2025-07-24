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
}

class TodoListPresenter: NSObject {
    private let viewController: TodoListProtocol
    private let repository: TodoRepository
    
    private var list: ListEntity
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let controller = NSFetchedResultsController(
            fetchRequest: repository.tasksByDoneFetchRequest(for: list),
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
    
    func numberOfRows() -> Int {
        guard let section = fetchedResultsController.sections?.first else { return 0 }
        
        return section.numberOfObjects
    }
    
    func object(at indexPath: IndexPath) -> TaskEntity {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func deleteList(at indexPath: IndexPath) async {
        let listEntity = fetchedResultsController.object(at: indexPath)
        do {
            try await repository.deleteList(objectID: listEntity.objectID)
        } catch {
            await MainActor.run {
                viewController.showError(error)
            }
        }
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
}

extension TodoListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        Task { @MainActor in
            viewController.tableViewBeginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        Task { @MainActor in
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
            default:
                break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        Task { @MainActor in
            viewController.tableViewEndUpdates()
        }
    }
}
