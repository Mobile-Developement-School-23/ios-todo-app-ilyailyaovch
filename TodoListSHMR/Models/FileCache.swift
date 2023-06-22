//
//  FileCache.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 10.06.2023.
//

import Foundation

/*  FileCache
〉Содержит закрытую для внешнего изменения, но открытую для получения коллекцию TodoItem
〉Содержит функцию добавления новой задачи
〉Содержит функцию удаления задачи (на основе id)
〉Содержит функцию сохранения всех дел в файл
〉Содержит функцию загрузки всех дел из файла
〉Можем иметь несколько разных файлов
〉Предусмотреть механизм защиты от дублирования задач (сравниванием id)
 */

enum FileCacheErrors: Error {
    case incorrectJson
    case saveItemsError
    case wrongDirectory
    case itemAlreadyExist
    case itemDoesntExist
    case itemCannotChange
    case CSVError
}

class FileCache {
    
    // Коллекция TodoItems
    private (set) var todoItems: [TodoItem] = []
    
    // Добавление новой задачи
    func add(item: TodoItem) {
        if let index = todoItems.firstIndex(where: {$0.id == item.id}){
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
    }
    
    // Удаление задачи (на основе id)
    func remove(id: String) throws {
        if let index = todoItems.firstIndex(where: {$0.id == id}) {
            todoItems.remove(at: index)
        } else {
            throw FileCacheErrors.itemDoesntExist
        }
    }
    
    // Сохранение всех дел в файл
    func saveItems(to file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent("\(file).json")
        
        // создаем список json элементов
        let jsonItems = todoItems.map({ $0.json })
        
        // записываем json элементы в файл
        let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
        try jsonData.write(to: pathWithFilename)
    }
    
    // Загрузка всех дел из файла
    func loadItems(from file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent("\(file).json")
        
        // получаем data по заданному пути
        let textData = try String(contentsOf: pathWithFilename, encoding: .utf8)
        guard
            let jsonData = textData.data(using: .utf8)
        else { throw FileCacheErrors.incorrectJson }
        
        // парсим data в массив
        guard
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : []) as? [[String: Any]]
        else { throw FileCacheErrors.incorrectJson }

        todoItems = jsonArray.compactMap { TodoItem.parse(json: $0)}
        }
    
}

extension FileCache {
    
    // Загрузка всех дел из файла
    func loadItemsCSV(from file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent("\(file).csv")
        
        // получаем text по заданному пути
        let textData = try String(contentsOf: pathWithFilename, encoding: .utf8)
        var textArr = textData.split(separator: "\n")
        textArr.remove(at: 0)

        todoItems = textArr.compactMap { TodoItem.parse(csv: String($0))}
    }
    
    // Сохранение всех дел в файл (applicationSupportDirectory)
    func saveItemsCSV(to file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent("\(file).csv")
        
        // записываем построчно элементы
        var csvLine = "id;text;importancy;deadline;isCompleted;dateCreated;dateModified\n"
        do {
            for item in todoItems {
                csvLine.append(item.csv + "\n")
            }
            try csvLine.write(to: pathWithFilename, atomically: true, encoding: .utf8)
            
        } catch {
            print(FileCacheErrors.saveItemsError)
        }
        
    }
}
