//
//  MainListPresenter.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//  Refactored by EMILY on 2025/07/18.

import Foundation
import CoreData

protocol MainListProtocol {
    func setupUI()
    func setupContainerView()
    func presentAddListViewController()
    func reloadData()
    func showError(_ error: Error)
}

final class MainListPresenter: NSObject {
    private let viewController: MainListProtocol
    private let repository: TodoRepository
    private lazy var fetchedResultsController: NSFetchedResultsController<ListEntity> = {
        let controller = NSFetchedResultsController(
            fetchRequest: repository.listsFetchRequest,
            managedObjectContext: repository.context,
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
        viewController.setupContainerView()
        loadData()
    }
    
    func addListButtonTapped() {
        viewController.presentAddListViewController()
    }
}

extension MainListPresenter {
    func loadData() {
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
}

extension MainListPresenter: NSFetchedResultsControllerDelegate {
    
}
