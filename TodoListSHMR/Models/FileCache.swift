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
    lazy var todoItems: [TodoItem] = []
    
    // Имя файла
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    // Добавление новой задачи
    func add(item: TodoItem) throws {
        if todoItems.first(where: {$0.id == item.id}) != nil{
            try change(item: item)
        } else {
            todoItems.append(item)
        }
    }
    
    // Доступ к имени файла
    func getFileName() -> (String) {
        return self.fileName
    }
    
    // Удаление задачи (на основе id)
    func remove(id: String) throws {
        guard
            let index = todoItems.firstIndex(where: {$0.id == id})
        else { throw FileCacheErrors.itemDoesntExist }
        todoItems.remove(at: index)
    }
    
    // Изменение задачи задачи, при одинаковом id
    func change(item: TodoItem) throws {
        guard
            let index = todoItems.firstIndex(where: {$0.id == item.id})
        else { throw FileCacheErrors.itemCannotChange}
        todoItems.remove(at: index)
        todoItems.insert(item, at: index)
    }
    
    // Сохранение всех дел в файл (applicationSupportDirectory)
    func saveItems(to file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent(file)
        
        // создаем список json элементов
        var jsonItems: [Any] = []
        for todoItem in todoItems{
            jsonItems.append(todoItem.json)
        }
        
        // записываем json элементы в файл
        if JSONSerialization.isValidJSONObject(jsonItems){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonItems)
                try jsonData.write(to: pathWithFilename)
            } catch {
                print(FileCacheErrors.saveItemsError)
            }
        }
    }
    
    // Загрузка всех дел из файла
    func loadItems(from file: String) throws {
        
        // формируем путь до файла
        guard
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent(file)
        
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
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent(file)
        
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
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { throw FileCacheErrors.wrongDirectory }
        let pathWithFilename = path.appendingPathComponent(file)
        
        // записываем построчно элементы
        var csvLine = "id;text;importancy;deadline;isComplited;dateCreated;dateModified\n"
        do {
            for item in todoItems {
                let itemStr = item.csv
                csvLine.append(itemStr)
            }
            try csvLine.write(to: pathWithFilename, atomically: true, encoding: .utf8)
            
        } catch {
            print(FileCacheErrors.saveItemsError)
        }
        
    }
}
