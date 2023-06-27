import UIKit

extension RootViewController: RootViewControllerProtocol{
    
    // MARK: - Setup RootView
    
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
        tableView.register(TableViewHeaderCell.self, forCellReuseIdentifier: TableViewHeaderCell.identifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewAddCell.self, forCellReuseIdentifier: TableViewAddCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupButton(){
        buttonView.addTarget(self, action: #selector(AddCellTapped), for: .touchUpInside)
        buttonView.setImage(Icon.PlusButton.image, for: .normal)
        buttonView.layer.shadowColor = UIColor.blue.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        buttonView.layer.shadowRadius = 5.0
        buttonView.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Constrains of RootViewController
    
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
