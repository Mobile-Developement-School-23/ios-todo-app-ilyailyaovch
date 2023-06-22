//
//  TodoViewControllerProtocol.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

protocol TodoViewControllerProtocol: AnyObject {

    /// ViewDidLoad
    func viewDidLoad()
    
    /// Scroll View
    func setupScrollView()
    
    /// CancelButton, SaveButton, title
    func setupNavigationBar()
    
    /// TextView, Details, Delete
    func setupBody()
    func setupStackView()
    
    /// TextView
    func setupTextView()
    
    /// Importancy, Dealine,  Calendar
    func setupDetailsStack()
    
    /// Plain divider, CalendarDivider
    func setupDivider(divider: UIView)
    
    /// DeleteButton
    func setupDeleteButton()
    
    /// Constrains for TodoViewBody
    func setupBodyConstrains()
}
