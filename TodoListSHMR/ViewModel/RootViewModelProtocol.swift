import UIKit

protocol RootViewModelProtocol {
    
    /// Load data from the file
    func fetchData()
    
    /// Open todo page
    func openToDo(with item: TodoItem?)
    
    /// Save todoItem
    func saveToDo(item: TodoItem)
    
    /// Delete todoItem
    func deleteToDo(id: String)
    
    /// Toggle todoItem
    func toggleCompletion(with item: TodoItem)
}
