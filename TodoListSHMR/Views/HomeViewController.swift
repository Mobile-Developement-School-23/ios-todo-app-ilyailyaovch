//
//  HomeViewController.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 13.06.2023.
//

import UIKit

class RootViewController: UIViewController {
    
    let welcomeButton = UIButton()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "First Screen"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupButton()
    }
    
    func setupButton() {
        
        //  add button
        view.addSubview(welcomeButton)
        
        // style button
        welcomeButton.configuration = .filled()
        welcomeButton.configuration?.baseBackgroundColor = .systemCyan
        welcomeButton.configuration?.title = "Next"
        
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
        
    }
    
}

