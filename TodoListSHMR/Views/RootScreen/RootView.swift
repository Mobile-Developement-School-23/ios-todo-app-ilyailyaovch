import UIKit

extension RootViewController: RootViewControllerProtocol {

    // MARK: - Setup RootView

    func setupHeader() {
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 0)

        // menuButtonView.setImage(Icon.Ellipsis.image, for: .normal)
        menuButtonView.setTitle("Сортировка", for: .normal)
        menuButtonView.configuration = .plain()
        menuButtonView.menu = makeMenu()
        menuButtonView.showsMenuAsPrimaryAction = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButtonView)
    }

    func setupLayout() {
        view.backgroundColor = Colors.backPrimary.color
        view.addSubview(tableView)
        view.addSubview(addButtonView)
    }

    func setupTableView() {
        tableView.backgroundColor = Colors.backPrimary.color
        tableView.register(TableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderCell.identifier)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewAddCell.self, forCellReuseIdentifier: TableViewAddCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupButton() {
        addButtonView.addTarget(self, action: #selector(addCellTapped), for: .touchUpInside)
        addButtonView.setImage(Icon.PlusButton.image, for: .normal)
        addButtonView.layer.shadowColor = UIColor.blue.cgColor
        addButtonView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        addButtonView.layer.shadowRadius = 5.0
        addButtonView.layer.shadowOpacity = 0.3
    }

    // MARK: - Constrains of RootViewController

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        menuButtonView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            // menuButtonView.widthAnchor.constraint(equalToConstant: 30),
            // menuButtonView.heightAnchor.constraint(equalToConstant: 30),

            addButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            addButtonView.widthAnchor.constraint(equalToConstant: 44),
            addButtonView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

extension RootViewController {
    func makeMenu() -> (UIMenu) {
        let alphaAscending = UIAction(title: "По алфавиту", image: UIImage(systemName: "arrow.up.right")) { action in
            rootViewModel.changeSortMode(to: SortMode.alphaAscending)
            self.reloadData()
        }
        let alphaDescending = UIAction(title: "По алфавиту", image: UIImage(systemName: "arrow.down.right")) { action in
            rootViewModel.changeSortMode(to: SortMode.alphaDescending)
            self.reloadData()
        }
        let createdAscending = UIAction(title: "По дате создания", image: UIImage(systemName: "arrow.up.right")) { action in
            rootViewModel.changeSortMode(to: SortMode.createdAscending)
            self.reloadData()
        }
        let createdDescending = UIAction(title: "По дате создания", image: UIImage(systemName: "arrow.down.right")) { action in
            rootViewModel.changeSortMode(to: SortMode.createdDescending)
            self.reloadData()
        }
        return UIMenu(title: "Сортировать", children: [alphaAscending, alphaDescending, createdAscending, createdDescending])
    }
}
