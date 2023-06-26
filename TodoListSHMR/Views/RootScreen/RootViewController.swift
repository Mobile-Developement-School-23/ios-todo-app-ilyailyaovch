import UIKit

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

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
        
        // fetch data
        rootViewModel.fetchData()
    }
    
    // MARK: - Setup
    
    func setupHeader(){
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout(){
        view.backgroundColor = Colors.backPrimary.color
        view.addSubview(tableView)
        view.addSubview(buttonView)
    }
    
    func setupTableView(){
        tableView.backgroundColor = Colors.backPrimary.color
//        tableView.register(TaskHeader.self, forCellReuseIdentifier: TaskHeader.identifier)
//        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.register(TableViewAddCell.self, forCellReuseIdentifier: TableViewAddCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupButton(){
        buttonView.addTarget(self, action: #selector(TappedButton), for: .touchUpInside)
        buttonView.setImage(Icon.PlusButton.image, for: .normal)
        buttonView.layer.shadowColor = UIColor.blue.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        buttonView.layer.shadowRadius = 5.0
        buttonView.layer.shadowOpacity = 0.3
    }
    
    func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            buttonView.widthAnchor.constraint(equalToConstant: 44),
            buttonView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Настройка ячейки таблицы

extension RootViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootViewModel.fileCache.todoItems.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == rootViewModel.fileCache.todoItems.count {
            // Строка последнего элемента "Новое"
            let newCell = tableView.dequeueReusableCell(withIdentifier: TableViewAddCell.identifier, for: indexPath)
            guard
                let newCell = newCell as? TableViewAddCell
            else { return UITableViewCell() }
            newCell.addCellTapped = { [weak self] in
                self?.TappedButton()
            }
            newCell.selectionStyle = .default
            return newCell
        } else {
            // Строки для todoItems
            return UITableViewCell()
        }
    }
}


// MARK: - @objc

extension RootViewController {

    @objc func TappedButton(){
        // Потом изменить
        // У Вью контроллера может быть другая модель
        let newNavViewController = UINavigationController(rootViewController: TodoViewController())
        present(newNavViewController, animated: true)
    }
}
