import UIKit
import CocoaLumberjackSwift

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

// MARK: - RootViewController

class RootViewController: UIViewController {

    let addButtonView = UIButton()
    let menuButtonView = UIButton()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let tableHeaderView = TableViewHeaderCell()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup UI
        setupHeader()
        setupLayout()
        setupTableView()
        setupButton()
        setupConstraints()

        // connect rootViewModel
        rootViewModel.viewController = self

        // fetch data
        rootViewModel.fetchData()
        rootViewModel.updateTodoListState()
    }
}

// MARK: - TableView

extension RootViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootViewModel.todoListState.count + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            tableView.cellForRow(at: indexPath) is TableViewCell
        else { return }
        let item = rootViewModel.todoListState[indexPath.row]
        rootViewModel.openToDo(with: item)
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.01 * Double(indexPath.row),
//            animations: { cell.alpha = 1 }
//        )
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == rootViewModel.todoListState.count {
            // Строка последнего элемента "Новое"
            let newCell = tableView.dequeueReusableCell(withIdentifier: TableViewAddCell.identifier, for: indexPath)
            guard
                let newCell = newCell as? TableViewAddCell
            else { return UITableViewCell() }
            newCell.addCellTapped = { [weak self] in self?.addCellTapped() }
            newCell.selectionStyle = .none
            return newCell
        } else {
            // Строки для todoItems
            let customCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
            guard
                let customCell = customCell as? TableViewCell
            else { return UITableViewCell() }
            let todoList = filterTodoList(list: rootViewModel.todoListState)
            let item = todoList[indexPath.row]
            customCell.configureCell(with: item)
            customCell.valueDidChange = { rootViewModel.toggleCompletion(with: item, at: indexPath) }
            customCell.selectionStyle = .none
            return customCell
        }
    }

    // MARK: table header
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView.textView.text = "Выполнено - \(rootViewModel.fileCache.todoItems.filter { $0.isCompleted }.count)"
        tableHeaderView.valueDidChange = { rootViewModel.updateTodoListState() }
        return tableHeaderView
    }

    // MARK: preview
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "Дело", children: [
                UIAction(title: "Посмотреть") { _ in
                    let item = rootViewModel.todoListState[indexPath.row]
                    rootViewModel.openToDo(with: item)
                },
                UIAction(title: "Удалить") { _ in
                    let item = rootViewModel.todoListState[indexPath.row]
                    rootViewModel.deleteToDo(id: item.id)
                }
            ])
        }
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            let item = rootViewModel.todoListState[indexPath.row]
            let controller = TodoViewController(with: item)
            let navigationController = UINavigationController(rootViewController: controller)
            return navigationController
        }, actionProvider: actionProvider)
        return config
    }

    // MARK: preview perform
    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        guard
            let previewedController = animator.previewViewController
        else { return }
        animator.addCompletion { self.present(previewedController, animated: true) }
    }

    // MARK: swipes lead
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Toggle action
        let toggle = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            let item  = rootViewModel.todoListState[indexPath.row]
            rootViewModel.toggleCompletion(with: item, at: indexPath)
            completionHandler(true)
        }
        if rootViewModel.todoListState[indexPath.row].isCompleted {
            toggle.image = UIImage(systemName: "circle")
            toggle.backgroundColor = Colors.gray.color
        } else {
            toggle.image = UIImage(systemName: "checkmark.circle.fill")
            toggle.backgroundColor = Colors.green.color
        }
        return UISwipeActionsConfiguration(actions: [toggle])
    }

    // MARK: swipes trail
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Info action
        let info = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            let item  = rootViewModel.todoListState[indexPath.row]
            rootViewModel.openToDo(with: item)
            completionHandler(true)
        }
        info.backgroundColor = Colors.grayLight.color
        info.image = UIImage(systemName: "info.circle.fill")
        // Trash action
        let trash = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            rootViewModel.deleteRow(at: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = Colors.red.color
        trash.image = UIImage(systemName: "trash.fill")

        let configuration = UISwipeActionsConfiguration(actions: [trash, info])
        return configuration
    }

    // MARK: filter todo
    func filterTodoList(list: [TodoItem]) -> ([TodoItem]) {
        // check presentation status
        switch rootViewModel.status {
        case Status.ShowAll:
            rootViewModel.todoListState = rootViewModel.fileCache.todoItems
        case Status.ShowUncompleted:
            rootViewModel.todoListState = rootViewModel.fileCache.todoItems.filter({ !$0.isCompleted })
        }
        // check sorting mode
        switch rootViewModel.sortMode {
        case SortMode.alphaAscending:
            rootViewModel.todoListState.sort { $0.text < $1.text }
        case SortMode.alphaDescending:
            rootViewModel.todoListState.sort { $0.text > $1.text }
        case SortMode.createdAscending:
            rootViewModel.todoListState.sort { $0.dateCreated < $1.dateCreated }
        case SortMode.createdDescending:
            rootViewModel.todoListState.sort { $0.dateCreated > $1.dateCreated }
        }
        return rootViewModel.todoListState
    }
}

// MARK: - Redoads

extension RootViewController {

    func reloadData() {
        tableView.reloadData()
    }

    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .right)
    }
}

// MARK: - @objc

extension RootViewController {

    @objc func addCellTapped() {
        rootViewModel.openToDo(with: nil)
    }
}
