import UIKit

final class RootViewModel: UIViewController {
    
    var fileName = "TodoCache"
    var fileCache = FileCache()
    weak var viewController: RootViewController?
}

extension RootViewModel: RootViewModelProtocol {
    
    func fetchData(){
        do{
            try fileCache.loadItems(from: rootViewModel.fileName)
        } catch {
            print("Error: loadItem")
        }
    }

    func openToDo(with item: TodoItem? = nil){
        let newItem = item ?? TodoItem(text: "")
        let newNavViewController = UINavigationController(rootViewController: TodoViewController(with: newItem))
        viewController?.present(newNavViewController, animated: true)
    }
    
    func saveToDo(item: TodoItem){
        do{
            self.fileCache.add(item: item)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.viewController?.updateData()
        } catch {
            print("Error: saveToDo()")
        }
    }
    
    func deleteToDo(id: String){
        do{
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.viewController?.updateData()
        } catch {
            print("Error: deleteToDo()")
        }
    }
    
    func toggleCompletion(with item: TodoItem){
        let newItem = TodoItem(id: item.id,
                               text: item.text,
                               importancy: item.importancy,
                               deadline: item.deadline,
                               isCompleted: !item.isCompleted,
                               dateCreated: item.dateCreated,
                               dateModified: item.dateModified
        )
        self.saveToDo(item: newItem)
    }
}
