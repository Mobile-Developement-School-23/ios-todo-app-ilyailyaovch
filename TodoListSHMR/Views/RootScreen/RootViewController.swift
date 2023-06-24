import UIKit

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

// MARK: - TodoViewController

class RootViewController: UIViewController {
    
    let buttonView = UIButton()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        setupHeader()
        setupLayout()
        setupTableView()
        setupConstraints()
        
        setupButton()
    }
    
    func setupHeader(){
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout(){
        view.backgroundColor = Colors.backPrimary.color
        view.addSubview(tableView)
        view.addSubview(buttonView) // Потом изменить кнопку
    }
    
    func setupTableView(){
        tableView.backgroundColor = Colors.backSecondary.color
//        tableView.register(TaskHeader.self, forCellReuseIdentifier: TaskHeader.identifier)
//        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.register(TableViewAddCell.self, forCellReuseIdentifier: TableViewAddCell.identifier)
    }
    
    func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupButton(){

        // style button
        buttonView.configuration = .filled()
        buttonView.configuration?.baseBackgroundColor = Colors.green.color
        buttonView.configuration?.title = "Отведу к TODO листу"
        // activate the button
        buttonView.addTarget(self, action: #selector(TappedButton), for: .touchUpInside)
        // for every UI element
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        //  group of constrains activated together
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonView.widthAnchor.constraint(equalToConstant: 200),
            buttonView.heightAnchor.constraint(equalToConstant: 50)
        ])
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
