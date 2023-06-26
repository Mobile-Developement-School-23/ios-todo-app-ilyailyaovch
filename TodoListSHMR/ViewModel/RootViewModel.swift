import UIKit

final class RootViewModel: UIViewController {
    
    var fileName = "TodoCache"
    var fileCache = FileCache()
}

extension RootViewModel: RootViewModelProtocol {
    
    // Fetch from the file
    func fetchData(){
        do{
            try fileCache.loadItems(from: rootViewModel.fileName)
        } catch {
            print("Error: loadItem")
        }
    }
    
    // Open todoItem
    func openToDo(with item: TodoItem? = nil){
        if item == nil {
            // новый
            let newNavViewController = UINavigationController(rootViewController: TodoViewController())
            present(newNavViewController, animated: true)
        } else {
            // существующий
        }
    }
}
