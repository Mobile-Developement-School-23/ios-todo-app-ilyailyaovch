import UIKit

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

// MARK: - RootViewController

class RootViewController: UIViewController {
    
    let addButtonView = UIButton()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var tableHeaderView = TableViewHeaderCell()

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

extension RootViewController: UITableViewDelegate, UITableViewDataSource{
    
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == rootViewModel.todoListState.count {
            // Строка последнего элемента "Новое"
            let newCell = tableView.dequeueReusableCell(withIdentifier: TableViewAddCell.identifier, for: indexPath)
            guard
                let newCell = newCell as? TableViewAddCell
            else { return UITableViewCell() }
            newCell.addCellTapped = { [weak self] in self?.AddCellTapped() }
            newCell.selectionStyle = .none
            return newCell
        } else {
            // Строки для todoItems
            let customCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
            guard
                let customCell = customCell as? TableViewCell
            else { return UITableViewCell() }
            
            let todoList = filterTodoList(list: rootViewModel.todoListState, status: rootViewModel.showCompleted)
            let item = todoList[indexPath.row]
            customCell.configureCell(with: item)
            customCell.valueDidChange = { rootViewModel.toggleCompletion(with: item) }
            customCell.selectionStyle = .none
            return customCell
        }
    }
    
    // MARK: table header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView = TableViewHeaderCell()
        tableHeaderView.valueDidChange = { /* тут или в функции не получиться вызвать redoad */}
        return tableHeaderView
    }
    
    // MARK: swipes lead
    func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Toggle action
        let toggle = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            let item  = rootViewModel.todoListState[indexPath.row]
            rootViewModel.toggleCompletion(with: item)
            completionHandler(true)
        }
        if rootViewModel.todoListState[indexPath.row].isCompleted{
            toggle.image = UIImage(systemName: "circle")
            toggle.backgroundColor = Colors.gray.color
        } else{
            toggle.image = UIImage(systemName: "checkmark.circle.fill")
            toggle.backgroundColor = Colors.green.color
        }
        return UISwipeActionsConfiguration(actions: [toggle])
    }
    
    // MARK: swipes trail
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
            let item  = rootViewModel.todoListState[indexPath.row]
            rootViewModel.deleteToDo(id: item.id)
            completionHandler(true)
        }
        trash.backgroundColor = Colors.red.color
        trash.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, info])
        return configuration
    }
    
    func filterTodoList(list: [TodoItem], status: Bool) -> ([TodoItem]){
        if status{
            return rootViewModel.fileCache.todoItems
        } else {
            return rootViewModel.fileCache.todoItems.filter( {!$0.isCompleted} )
        }
    }
}

// MARK: - Redoads

extension RootViewController{
    
    func updateData(){
        tableView.reloadData()
    }
}

// MARK: - @objc

extension RootViewController {

    @objc func AddCellTapped(){
        rootViewModel.openToDo(with: nil)
    }
    
    @objc func extraButtonTapped(){
        
    }
}
