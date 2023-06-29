import UIKit

//MARK: - RootViewModel

enum Status {
    case ShowAll
    case ShowUncompleted
}

final class RootViewModel: UIViewController {
    
    var fileName = "TodoCache"
    var fileCache = FileCache()
    weak var viewController: RootViewController?
    
    var todoListState = [TodoItem]()
    public private(set) var status: Status = Status.ShowUncompleted
    
    init(fileName: String = "TodoCache",
         fileCache: FileCache = FileCache()){
        super.init(nibName: nil, bundle: nil)
        self.fileName = fileName
        self.fileCache = fileCache
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RootViewModel: RootViewModelProtocol {
    
    //MARK: - CRUD functions
    
    func fetchData(){
        do{
            try fileCache.loadItems(from: rootViewModel.fileName)
        } catch {
            print("Error: fetchData()")
        }
    }

    func openToDo(with item: TodoItem? = nil){
        let newItem = item ?? TodoItem(text: "")
        let newNavViewController = UINavigationController(rootViewController: TodoViewController(with: newItem))
        newNavViewController.modalTransitionStyle = .coverVertical
        newNavViewController.modalPresentationStyle = .formSheet
        viewController?.present(newNavViewController, animated: true)
    }
    
    func saveToDo(item: TodoItem){
        do{
            self.fileCache.add(item: item)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
        } catch {
            print("Error: saveToDo()")
        }
    }
    
    func deleteToDo(id: String){
        do{
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
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
    
    //MARK: - todoListState presentation
    
    func updateTodoListState(){
        switch status{
        case Status.ShowUncompleted:
            self.todoListState = self.fileCache.todoItems.filter( {!$0.isCompleted} )
        case Status.ShowAll:
            self.todoListState = self.fileCache.todoItems
        }
        self.viewController?.updateData()
    }

    func changePresentationStatus(to newStatus: Status) {
        self.status = newStatus
    }
}
