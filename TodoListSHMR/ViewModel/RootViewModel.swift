import UIKit

final class RootViewModel: UIViewController {
    
    var fileName = "TodoCache"
    var fileCache = FileCache()
    weak var viewController: RootViewController?
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
        let newItem = item ?? TodoItem(text: "")
        let newNavViewController = UINavigationController(rootViewController: TodoViewController(with: newItem))
        viewController?.present(newNavViewController, animated: true)
    }
}
