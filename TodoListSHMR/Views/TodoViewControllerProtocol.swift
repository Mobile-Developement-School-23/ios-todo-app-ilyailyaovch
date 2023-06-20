//
//  TodoViewControllerProtocol.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

protocol TodoViewControllerProtocol {

    /// ViewDidLoad
    func viewDidLoad()
    
    /// CancelButton, SaveButton, title
    func setupNavigationBar()
    
    /// TextView, Details, Delete
    func setupBody()
    func setupStackView()
    
    /// TextView
    func setupTextView()
    
    /// Importancy, Dealine,  Calendar
    func setupDetailsStack()
    
    /// DeleteButton
    func setupDeleteButton()
    
    /// Constrains for TodoViewBody
    func setupBodyConstrains()
}
