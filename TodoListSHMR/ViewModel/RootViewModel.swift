import UIKit
import CocoaLumberjackSwift

enum Status {
    case ShowAll
    case ShowUncompleted
}

enum SortMode {
    case alphaAscending
    case alphaDescending
    case createdAscending
    case createdDescending
}

// MARK: - RootViewModel

final class RootViewModel: UIViewController {

    var fileName = "TodoCache"
    var fileCache = FileCache()
    var todoListState = [TodoItem]()
    var isDirty = true

    weak var viewController: RootViewController?

    let network: NetworkingService = DefaultNetworkingService()

    public private(set) var status: Status = Status.ShowUncompleted
    public private(set) var sortMode: SortMode = SortMode.createdDescending

    init(fileName: String = "TodoCache",
         fileCache: FileCache = FileCache()) {
        super.init(nibName: nil, bundle: nil)
        self.fileName = fileName
        self.fileCache = fileCache
        DDLog.add(DDOSLogger.sharedInstance)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CRUD Network

extension RootViewModel {

    func fetchDataNetwork() {
        Task {
            do {
                let itemsFromNetwork = try await network.getList()
                fetchDataClient(with: itemsFromNetwork)
                self.isDirty = false
            } catch {
                self.isDirty = true
            }
        }
    }

    func deleteToDoNetwork(id: String) {

        if self.isDirty {
            fetchDataNetwork()
        }

        Task {
            do {
                _ = try await network.deleteElement(by: id)
                self.isDirty = false
            } catch {
                self.isDirty = true
            }
        }
    }

    func addToDoNetwork(item: TodoItem) {

        if self.isDirty {
            fetchDataNetwork()
        }

        Task {
            do {
                _ = try await network.postElem(with: item)
                self.isDirty = false
            } catch {
                self.isDirty = true
            }
        }
    }

    func changeToDoNetwork(item: TodoItem) {

        if self.isDirty {
            fetchDataNetwork()
        }

        Task {
            do {
                _ = try await network.putElement(with: item)
                self.isDirty = false
            } catch {
                self.isDirty = true
            }
        }
    }

    @MainActor
    func fetchDataClient(with items: [TodoItem]) {
        self.fileCache.set(items: items)
        self.saveData()
        self.updateTodoListState()
    }
}

extension RootViewModel: RootViewModelProtocol {

    // MARK: - CRUD functions

    func saveData() {
        do {
            try fileCache.saveItems(to: self.fileName)
        } catch {
            DDLogError("Error: saveData()")
        }
    }

    func fetchData() {
        do {
            try fileCache.loadItems(from: self.fileName)
            self.updateTodoListState()
        } catch {
            DDLogError("Error: fetchData()")
        }
    }

    func openToDo(with item: TodoItem? = nil) {
        let newItem = item ?? TodoItem(text: "")
        let newNavViewController = UINavigationController(rootViewController: TodoViewController(with: newItem))
        newNavViewController.modalTransitionStyle = .coverVertical
        newNavViewController.modalPresentationStyle = .formSheet
        viewController?.present(newNavViewController, animated: true)
    }

    func saveToDo(item: TodoItem, reload: Bool) {
        do {
            // добавить или изменить элемент в локальном файле
            let addedTaskType = self.fileCache.add(item: item)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            // обновить список показа
            if reload { self.updateTodoListState() }
            // добавить или изменить на сервере
//            switch addedTaskType {
//            case .new:
//                addToDoNetwork(item: item)
//            case .changed:
//                changeToDoNetwork(item: item)
//            }
        } catch {
            DDLogError("Error: saveToDo()")
        }
    }

    func deleteToDo(id: String) {
        do {
            // удалить в локальном файле
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            // обновить список показа
            self.updateTodoListState()
            // удалить на сервере
//            self.deleteToDoNetwork(id: id)
        } catch {
            DDLogError("Error: deleteToDo()")
        }
    }

    func deleteRow(at indexPath: IndexPath) {
        let id = self.todoListState[indexPath.row].id
        do {
            // удалить в локальном файле
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            // обновить показ списка
            self.todoListState.remove(at: indexPath.row)
            self.viewController?.deleteRow(at: indexPath)
            // удалить на сервере
//            self.deleteToDoNetwork(id: id)
        } catch {
            DDLogError("Error: deleteToDo()")
        }
    }

    func toggleCompletion(with item: TodoItem, at indexPath: IndexPath) {
        // создание нового элемента с инвертированным статусом
        let newItem = TodoItem(
            id: item.id,
            text: item.text,
            importancy: item.importancy,
            deadline: item.deadline,
            isCompleted: !item.isCompleted,
            dateCreated: item.dateCreated,
            dateModified: item.dateModified
        )
        // сохранение изменения в хранилищах
        self.saveToDo(item: newItem, reload: false)
        // обновить показ списка
        switch self.status {
        case Status.ShowAll:
            self.todoListState = self.fileCache.todoItems
            self.viewController?.reloadRow(at: indexPath)
        case Status.ShowUncompleted:
            self.todoListState.remove(at: indexPath.row)
            self.viewController?.deleteRow(at: indexPath)
            self.viewController?.reloadData()
        }
        // обновить счетчик в заголовке
        let counter = rootViewModel.fileCache.todoItems.filter {$0.isCompleted}.count
        self.viewController?.tableHeaderView.textView.text = "Выполнено - \(counter)"
    }

    // MARK: - todoListState presentation

    func updateTodoListState() {
        switch self.status {
        case Status.ShowUncompleted:
            self.todoListState = self.fileCache.todoItems.filter({!$0.isCompleted})
        case Status.ShowAll:
            self.todoListState = self.fileCache.todoItems
        }
        self.viewController?.reloadData()
    }

    func changePresentationStatus(to newStatus: Status) {
        self.status = newStatus
    }

    func changeSortMode(to newMode: SortMode) {
        self.sortMode = newMode
    }
}
