import Foundation

final class TodoViewModel {
    
    weak var viewController: TodoViewController?
    
    var item: TodoItem?
    var state: TodoItemState
    
    init(item: TodoItem) {
        self.state = TodoItemState(item: item)
    }
}

extension TodoViewModel: TodoViewModelProtocol {
    
    func saveItem(item: TodoItem){
        do{
            rootViewModel.fileCache.add(item: item)
            try rootViewModel.fileCache.saveItems(to: rootViewModel.fileName)
            viewController?.dismiss(animated: true)
            rootViewModel.viewController?.updateData()
        } catch {
            print("Error: saveItem")
        }
    }

    func deleteItem(id: String) {
        do{
            try rootViewModel.fileCache.remove(id: id)
            try rootViewModel.fileCache.saveItems(to: rootViewModel.fileName)
            rootViewModel.viewController?.updateData()
        } catch {
            viewController?.dismiss(animated: true)
        }
    }
    
    func loadData(){
        if !state.text.isEmpty{
            viewController?.textView.text = state.text
            viewController?.textView.textColor = Colors.labelPrimary.color
        }
        viewController?.importancyView.importancy = state.importancy
        viewController?.deadlineView.deadline = state.deadline
        viewController?.activateButtons()
    }
}
