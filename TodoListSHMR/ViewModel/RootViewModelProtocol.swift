import UIKit

protocol RootViewModelProtocol {
    
    /// Load data from the file
    func fetchData()
    
    /// Open todo page
    func openToDo(with item: TodoItem?)
}
