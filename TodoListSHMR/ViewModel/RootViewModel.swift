import UIKit

//MARK: - RootViewModel

final class RootViewModel: UIViewController {
    
    var fileName = "TodoCache"
    var fileCache = FileCache()
    weak var viewController: RootViewController?
    
    var fullTodoList = [TodoItem]()
    var completedTodoList = [TodoItem]()
    var todoListState = [TodoItem]()
    var showCompleted: Bool = false
    
    init(fileName: String = "TodoCache",
         fileCache: FileCache = FileCache(),
         viewController: RootViewController? = nil){
        super.init(nibName: nil, bundle: nil)
        self.fileName = fileName
        self.fileCache = fileCache
        self.viewController = viewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RootViewModel: RootViewModelProtocol {
    
    //MARK: - CRUD functions
    
    func updateData(){
        viewController?.updateData()
    }
    
    func updateTodoListState(){
        if self.showCompleted{
            self.todoListState = self.fileCache.todoItems
        } else {
            self.todoListState = self.fileCache.todoItems.filter( {!$0.isCompleted} )
        }
        self.viewController?.updateData()
    }
    
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
        newNavViewController.modalTransitionStyle = .coverVertical
        newNavViewController.modalPresentationStyle = .formSheet
        viewController?.present(newNavViewController, animated: true)
    }
    
    func saveToDo(item: TodoItem){
        do{
            self.fileCache.add(item: item)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
            self.viewController?.updateData()
        } catch {
            print("Error: saveToDo()")
        }
    }
    
    func deleteToDo(id: String){
        do{
            try self.fileCache.remove(id: id)
            try self.fileCache.saveItems(to: rootViewModel.fileName)
            self.updateTodoListState()
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
    
    //MARK: - List presentation

    func addCompletedToPresentation(){
        showCompleted = true

    }
    
    func removeCompletedToPresentation(){
        showCompleted = false
    }
    
}




