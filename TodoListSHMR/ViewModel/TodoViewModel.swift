import Foundation

final class TodoViewModel {
    
    weak var viewController: TodoViewController?
    
    var item: TodoItem?
    var state: TodoItemState
    
    // Потом изменить 1111111111111111111111
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
            try rootViewModel.fileCache.saveItems(to: rootViewModel.fileName)
        } catch {
            viewController?.dismiss(animated: true)
        }
    }
    
    // Потом изменить
    // Подавать № todoItem
    func loadData(){
        do{
            try rootViewModel.fileCache.loadItems(from: rootViewModel.fileName)
            if !rootViewModel.fileCache.todoItems.isEmpty{
                self.state = TodoItemState(item: rootViewModel.fileCache.todoItems[0])
                setupView()
            }
        } catch {
            print("Error: loadItem")
        }
    }
    
    func setupView(){
        viewController?.textView.text = state.text
        viewController?.textView.textColor = Colors.labelPrimary.color
        viewController?.importancyView.importancy = state.importancy
        viewController?.deadlineView.deadline = state.deadline
        viewController?.activateButtons()
    }
}
