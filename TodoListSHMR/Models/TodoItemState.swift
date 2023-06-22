//
//  TodoItemState.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 22.06.2023.
//

import Foundation

struct TodoItemState {
    
    let id: String
    var text: String
    var importancy: Importancy
    var deadline: Date?
    var isCompleted: Bool
    var dateCreated: Date
    var dateModified: Date?
    
    init(item: TodoItem) {
        id = item.id
        text = item.text
        importancy = item.importancy
        deadline = item.deadline
        isCompleted = item.isCompleted
        dateCreated = item.dateCreated
        dateModified = item.dateModified
    }
}
