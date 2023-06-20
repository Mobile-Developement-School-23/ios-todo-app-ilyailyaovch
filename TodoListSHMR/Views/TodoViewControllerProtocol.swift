//
//  TodoViewControllerProtocol.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

protocol TodoViewControllerProtocol {

    func viewDidLoad()

    func setupNavigationBar()
    
    func setupBody()
    func setupStackView()
    func setupTextView()
    func setupDetailsStack()
    func setupDeleteButton()
    
    func setupBodyConstrains()
}
