# ToDoList
> [storyboard 기반으로 처음 구현한 할 일 관리 앱](https://github.com/emilyj4482/ToDoList)을 codebase로 리팩토링 한 프로젝트입니다.
## 기술 스택
- 코드베이스 `UIKit`
- `MVP` Architecture
- Coordinator 패턴
- `CoreData` CRUD
- Swift Concurrency
## 프로젝트 구조
```
📦 ToDoList
├── 📂 Delegate
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── 📂 Helper
│   ├── AppCoordinator.swift
│   ├── CoreDataError.swift
│   └── EditTaskMode.swift
├── 📂 Model
│   ├── CoreDataManager.swift
│   ├── TodoRepository.swift
│   └── Todo.xcdatamodeld
├── 📂 Scene
│   ├── 📂 Main
│   │   ├─ MainListCoordinator.swift
│   │   ├─ MainListViewController.swift
│   │   ├─ MainListView.swift
│   │   ├─ ListCell.swift
│   │   └─ MainListPresenter.swift
│   ├── 📂 AddList
│   │   ├─ AddListCoordinator.swift
│   │   ├─ AddListViewController.swift
│   │   └─ AddListPresenter.swift
│   ├── 📂 Todo
│   │   ├─ TodoListCoordinator.swift
│   │   ├─ TodoListViewController.swift
│   │   ├─ TodoListView.swift
│   │   ├─ TaskCell.swift
│   │   ├─ TaskDoneHeader.swift
│   │   └─ TodoListPresenter.swift
│   ├── 📂 EditTask
│   │   ├─ EditTaskCoordinator.swift
│   │   ├─ EditTaskViewController.swift
│   │   ├─ EditTaskView.swift
│   │   └─ EditTaskPresenter.swift
├── Assets.xcassets
└── Info.plist
```
## 주요 구현사항
### 📌 ContainerView 운영
UI 컴포넌트들을 컨테이너 뷰에서 그리고, `Controller`에는 컨테이너 뷰만 `subview`로 추가하여 `Controller`의 책임을 덜고 코드를 줄였습니다.
```swift
class MainListViewController: UIViewController {
    private let containerView = MainListView()

    // ... //

    private func setupUI() {
        view.addSubView(containerView)

        // ... //
    }
}
```
```swift
class MainListView: UIView {
    private let tableView: UITableView = { // ... // }()

    private let countLabel: UILabel = { // ... // }()

    private lazy var addListButton: UIButton = { // ... // }()
}
```
### 📌 Coordinator 패턴 적용
네비게이션(화면 전환) 책임을 담당하는 `Coordinator`를 추가하여 `Controller`의 책임을 덜었습니다.
> [구현 과정을 정리한 포스트](https://velog.io/@emilyj4482/iOS-Coordinator)
```swift
final class TodoListCoordinator: Coordinator {
    weak var parentCoordinator: MainListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let repository: TodoRepository
    
    init(navigationController: UINavigationController, repository: TodoRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start(with list: ListEntity) {
        let viewController = TodoListViewController(repository: repository, list: list)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish(shouldPop: Bool) {
        if shouldPop {
            navigationController.popViewController(animated: true)
        }
        parentCoordinator?.childDidFinish(self)
    }

    // ... //
}
```
- `Controller`는 메모리 누수 방지를 위해 `Coorinator`를 약한 참조
```swift
class TodoListViewController: UIViewController {
    weak var coordinator: TodoListCoordinator?
}
```
### 📌 MVP 아키텍처 적용
`Presenter`는 `View`의 이벤트를 받고 → `Model`에서 데이터를 받아 가공 후 → `View`에 전달하는 역할을 담당하여 명령형 업데이트 패턴의 중심 객체입니다. 명령형 UI 프레임워크인 `UIKit`에 적합한지, `MVC`나 `MVVM` 아키텍처와 어떤 차이가 있는지에 대한 학습 목적으로 `MVP` 아키텍처를 채택하였습니다.
> [MVP 아키텍처에 대해 정리한 포스트](https://velog.io/@emilyj4482/iOS-MVP-Architecture)
```swift
protocol AddListProtocol: AnyObject {
    func setupUI()
    func dismiss()
    func showAlert()
}

final class AddListPresenter: NSObject {
    private weak var viewController: AddListProtocol?
    private let repository: TodoRepository
    
    init(viewController: AddListProtocol, repository: TodoRepository) {
        self.viewController = viewController
        self.repository = repository
    }
    
    func viewDidLoad() {
        viewController?.setupUI()
    }
    
    func leftBarButtonTapped() {
        viewController?.dismiss()
    }
    
    func rightBarButtonTapped(_ input: String) {
        // ... //
    }
}
```
```swift
class AddListViewController: UIViewController, AddListProtocol {
    private lazy var presenter = AddListPresenter(viewController: self, repository: repository)
    private var repository: TodoRepository

    // ... //

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    // ... //

    @objc private func leftBarButtonTapped() {
        presenter.leftBarButtonTapped()
    }
    
    @objc private func rightBarButtonTapped() {
        if let input = textField.text {
            presenter.rightBarButtonTapped(input)
        }
    }
}
```
### 📌 CoreData CRUD 비동기로 구현 (+ Swift Concurrency)
`Read`는 `viewContext(메인 스레드)`, `Create`, `Update`, `Delete`는 `backgroundContext(백그라운드 스레드)`에서 작동하도록 데이터 핸들링을 비동기 처리 하였습니다. 이 과정은 context 병합 정책(MergePolicy)에 대해 제대로 이해하는 계기가 되었습니다.
> [CoreData 비동기 처리 과정을 정리한 포스트](https://velog.io/@emilyj4482/iOS-CoreData-%EB%B9%84%EB%8F%99%EA%B8%B0-%EC%B2%98%EB%A6%AC)
- CoreDataManager : 영구 저장소(Container)를 하나만 운영하기 위해 싱글톤으로 관리. 컨테이너와 context를 관리하는 객체
```swift
final class CoreDataManaer {
    static let shared = CoreDataManager()
    private init() {}

    private var persistentContainer: NSPersistentContainer = { // ... // }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
}
```
- TodoRepository : CoreDataManager를 참조하여 FetchRequest와 Todo 데이터의 CRUD를 담당하는 객체. `Presenter`들이 레포지토리를 참조하여 데이터를 `View`에 갱신
```swift
final class TodoRepository {
    private let coreDataManager = CoreDataManager.shared
    
    var viewContext: NSManagedObjectContext {
        return coreDataManager.viewContext
    }

    var listsFetchRequest: NSFetchRequest<ListEntity> { // ... // }

    func tasksFetchRequest(for list: ListEntity) -> NSFetchRequest<TaskEntity> { // ... // }

    // ... //
}
```
### 📌 NSFetchedResultsController + UITableView로 데이터 리로드 구현
NSFetchedResultsController는 `CoreData` 적용 프로젝트에서 `FetchRequest`를 통해 편리하게 `UITableView` 또는 `UICollectionView`의 데이터를 갱신하도록 해주는 클래스입니다. 데이터 변경 시 `tableView.reloadData()`를 수동 호출할 필요 없이 변경사항이 감지되면 `UI`가 자동으로 업데이트 됩니다.
> [NsFetchedResultsController 적용 과정을 정리한 포스트](https://velog.io/@emilyj4482/UIKit-NSFetchedResultsController#%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B0%94%EC%9D%B8%EB%94%A9)
```swift
final class MainListPresenter: NSObject {
    // ... //

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
}

extension MainListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        viewController?.tableViewBeginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                viewController?.tableViewInsertRows(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                viewController?.tableViewReloadRows(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                viewController?.tableViewDeleteRows(at: [indexPath])
            }
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        viewController?.tableViewEndUpdates()
        viewController?.configure(with: numberOfRows())
    }
}
```
### 📌 Error handling
데이터 CRUD 메소드들을 `throws`로 구현하여 에러 발생 시 `alert`이 호출되도록 처리하였습니다. (사용자 경험 개선)
```swift
final class TodoRepository {
    // ... //

    func renameList(objectID: NSManagedObjectID, newName: String) async throws {
        let backgroundContext = coreDataManager.newBackgroundContext()
        
        // 중복 검사
        let processedName = try await processListName(newName)
        
        try await backgroundContext.perform {
            let managedObject = try backgroundContext.existingObject(with: objectID)
            
            guard let list = managedObject as? ListEntity else {
                throw CoreDataError.castingObjectFailed
            }
            
            list.name = processedName
            try backgroundContext.save()
        }
    }
}
```
```swift
final class TodoListPresenter: NSObject {
    // ... //

    func renameList(with name: String) async {
        do {
            try await repository.renameList(objectID: list.objectID, newName: name)
        } catch {
            viewController?.showError(error)
        }
    }
}
```
```swift
class TodoListViewController: TodoListProtocol {
    // ... //

    func showError(_ error: Error) {
        print("[Error] \(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "Error",
            message: "Data could not be loaded. Please try again later.",
            preferredStyle: .alert
        )
        
        let okayButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
}
```
