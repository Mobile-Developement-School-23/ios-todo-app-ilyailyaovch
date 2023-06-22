//
//  TodoViewModelProtocol.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

protocol TodoViewModelProtocol {
    
    func saveItem(item: TodoItem)
    
    func deleteItem(id: String)
}
