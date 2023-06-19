//
//  TodoViewController.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 19.06.2023.
//

import UIKit

class TodoViewController: UIViewController, UIScrollViewDelegate {
    
    // Properties
    
    private var viewModel: TodoViewModel = TodoViewModel()
    
    
    // Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.green.color
        
    }
    
}
