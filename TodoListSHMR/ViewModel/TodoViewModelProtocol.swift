import UIKit

protocol TodoViewModelProtocol {
    
    func saveItem(item: TodoItem)
    
    func deleteItem(id: String)
    
    func loadData()
}
