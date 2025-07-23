//
//  MainListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/18.

import Foundation
import CoreData

protocol MainListProtocol {
    func setupNavigationBar()
    func setupUI()
    func setupContainerView()
    func presentAddListViewController()
    func pushToTodoListViewController(with list: ListEntity)
    func reloadData()
    func showError(_ error: Error)
    func showActionSheet(indexPath: IndexPath)
    func tableViewBeginUpdates()
    func tableViewEndUpdates()
    func tableViewInsertRows(at indexPaths: [IndexPath])
    func tableViewReloadRows(at indexPaths: [IndexPath])
    func tableViewDeleteRows(at indexPaths: [IndexPath])
}

final class MainListPresenter: NSObject {
    private let viewController: MainListProtocol
    private let repository: TodoRepository
    private lazy var fetchedResultsController: NSFetchedResultsController<ListEntity> = {
        let controller = NSFetchedResultsController(
            fetchRequest: repository.listsFetchRequest,
            managedObjectContext: repository.viewContext,
            sectionNameKeyPath: nil,
            cacheName: Keys.fetchedResultsControllerListCacheName
        )
        
        controller.delegate = self
        return controller
    }()
    
    init(viewController: MainListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController.setupUI()
        viewController.setupNavigationBar()
        viewController.setupContainerView()
        loadLists()
    }
    
    func addListButtonTapped() {
        viewController.presentAddListViewController()
    }
    
    func didSelectRow(at index: Int) {
        if let list = repository.fetchList(at: index) {
            viewController.pushToTodoListViewController(with: list)
        } else {
            viewController.showError(CoreDataError.fetchingObjectFailed)
        }
    }
}

extension MainListPresenter {
    func loadLists() {
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
    
    func object(at indexPath: IndexPath) -> ListEntity {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func showActionSheet(indexPath: IndexPath) {
        viewController.showActionSheet(indexPath: indexPath)
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
}

extension MainListPresenter: NSFetchedResultsControllerDelegate {
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
