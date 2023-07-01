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
    weak var viewController: RootViewController?

    var todoListState = [TodoItem]()
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

extension RootViewModel: RootViewModelProtocol {

    // MARK: - CRUD functions

    func fetchData() {
        do {
            try fileCache.loadItems(from: rootViewModel.fileName)
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

    func saveToDo(item: TodoItem) {
        do {
            self.fileCache.add(item: item)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
        } catch {
            DDLogError("Error: saveToDo()")
        }
    }

    func deleteToDo(id: String) {
        do {
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
        } catch {
            DDLogError("Error: deleteToDo()")
        }
    }

    func deleteRow(at indexPath: IndexPath) {
        let id = self.todoListState[indexPath.row].id
        do {
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.todoListState.remove(at: indexPath.row)
            self.viewController?.deleteRow(at: indexPath)
        } catch {
            DDLogError("Error: deleteToDo()")
        }
    }

    func toggleCompletion(with item: TodoItem, at indexPath: IndexPath) {
        let newItem = TodoItem(
            id: item.id,
            text: item.text,
            importancy: item.importancy,
            deadline: item.deadline,
            isCompleted: !item.isCompleted,
            dateCreated: item.dateCreated,
            dateModified: item.dateModified
        )
        switch self.status {
        case Status.ShowAll:
            self.fileCache.add(item: newItem)
            try? self.fileCache.saveItems(to: rootViewModel.fileName)
            self.todoListState = self.fileCache.todoItems
            self.viewController?.reloadRow(at: indexPath)
        case Status.ShowUncompleted:
            self.fileCache.add(item: newItem)
            try? self.fileCache.saveItems(to: rootViewModel.fileName)
            self.todoListState.remove(at: indexPath.row)
            self.viewController?.deleteRow(at: indexPath)
            self.viewController?.reloadData()
        }
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
