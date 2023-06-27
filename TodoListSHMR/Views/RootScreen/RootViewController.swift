import UIKit

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

// MARK: - RootViewController

class RootViewController: UIViewController {
    
    let buttonView = UIButton()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)

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
    }
}

// MARK: - TableView

extension RootViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootViewModel.fileCache.todoItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            tableView.cellForRow(at: indexPath) is TableViewCell
        else { return }
        let item = rootViewModel.fileCache.todoItems[indexPath.row]
        rootViewModel.openToDo(with: item)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == rootViewModel.fileCache.todoItems.count {
            // Строка последнего элемента "Новое"
            let newCell = tableView.dequeueReusableCell(withIdentifier: TableViewAddCell.identifier, for: indexPath)
            guard
                let newCell = newCell as? TableViewAddCell
            else { return UITableViewCell() }
            newCell.addCellTapped = { [weak self] in self?.AddCellTapped() }
            return newCell
        } else {
            // Строки для todoItems
            let customCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
            guard
                let customCell = customCell as? TableViewCell
            else { return UITableViewCell() }
            let item = rootViewModel.fileCache.todoItems[indexPath.row]
            customCell.configureCell(with: item)
            customCell.selectionStyle = .none
            return customCell
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
}
