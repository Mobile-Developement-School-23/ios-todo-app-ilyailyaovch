//
//  RootViewController.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 13.06.2023.
//

import UIKit

/// Global variable which contains fileCache
var rootViewModel: RootViewModel = RootViewModel()

class RootViewController: UIViewController {
    
    let welcomeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButton()
    }
    
    func setupView(){
        view.backgroundColor = Colors.backPrimary.color
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupButton() {
        
        //  add button
        view.addSubview(welcomeButton)
        // style button
        welcomeButton.configuration = .filled()
        welcomeButton.configuration?.baseBackgroundColor = Colors.green.color
        welcomeButton.configuration?.title = "Отведу к TODO листу"
        // activate the button
        welcomeButton.addTarget(self, action: #selector(TappedButton), for: .touchUpInside)
        // for every UI element
        welcomeButton.translatesAutoresizingMaskIntoConstraints = false
        //  group of constrains activated together
        NSLayoutConstraint.activate([
            welcomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeButton.widthAnchor.constraint(equalToConstant: 200),
            welcomeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func TappedButton(){
        // Потом изменить
        // У Вью контроллера может быть другая модель
        let newNavViewController = UINavigationController(rootViewController: TodoViewController())
        present(newNavViewController, animated: true)
        
    }
       
}

