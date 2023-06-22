//
//  TodoViewModel.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 19.06.2023.
//

import Foundation

final class TodoViewModel {
    
    weak var viewController: TodoViewController?
    
    var item: TodoItem?
    var state: TodoItemState
    
    init() {
        self.state = TodoItemState(item: TodoItem(text: ""))
    }
}

extension TodoViewModel: TodoViewModelProtocol {
    
    func saveItem(item: TodoItem){
        do{
            rootViewModel.fileCache.add(item: item)
            try rootViewModel.fileCache.saveItems(to: rootViewModel.fileName)
            viewController?.dismiss(animated: true)
        } catch {
            print("Error: saveItem")
        }
        print(item)
    }
    
    func deleteItem(id: String) {
        do{
            try rootViewModel.fileCache.remove(id: id)
        } catch {
            print("Error: deleteItem")
        }
    }
    
    //Потом изменить
    //Написать load непонятно откуда
    
}
