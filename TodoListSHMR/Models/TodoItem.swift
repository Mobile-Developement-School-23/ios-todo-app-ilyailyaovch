//
//  TodoItem.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 09.06.2023.
//

import Foundation

/*  TodoItem
〉Иммутабельная структура
〉Содержит уникальный идентификатор id, если не задан пользователем - генерируется (UUID().uuidString)
〉Содержит обязательное строковое поле - text
〉Содержит обязательное поле важность, должно быть enum, может иметь три варианта - "неважная", "обычная" и "важная"
〉Содержит дедлайн, может быть не задан, если задан - дата
〉Содержит флаг того, что задача сделана
〉Содержит две даты - дата создания задачи (обязательна) и дата изменения (опциональна)
*/

enum Importancy: String {
    case important
    case common
    case unImportant
}

struct TodoItem {
    
    let id:             String
    let text:           String
    var importancy:     Importancy
    let deadline:       Date?
    var isComplited:    Bool
    let dateCreated:    Date
    let dateModified:   Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importancy: Importancy = Importancy.common,
         deadline: Date? = nil,
         isComplited: Bool = false,
         dateCreated: Date = Date(),
         dateModified: Date? = nil) {
        self.id = id
        self.text = text
        self.importancy = importancy
        self.deadline = deadline
        self.isComplited = isComplited
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}

/*  TodoItem, parsing json
〉Расширение для структуры TodoItem
〉Содержит функцию (static func parse(json: Any) -> TodoItem?) для разбора json
〉Содержит вычислимое свойство (var json: Any) для формирования json'а
〉Не сохранять в json важность, если она "обычная"
〉Не сохранять в json сложные объекты (Date)
〉Сохранять deadline только если он задан
〉Обязательно использовать JSONSerialization (т.е. работу со словарем)
*/

extension TodoItem {
    
    // Разбор json
    static func parse(json: Any) -> TodoItem?{
        guard let jsonObject = json as? [String: Any] else { return nil }
        guard
            let id = jsonObject["id"] as? String,
            let text = jsonObject["text"] as? String,
            let importancyString = jsonObject["importancy"] as? String,
            let isCompleted = jsonObject["isComplited"] as? Bool,
            let dateCreatedDouble = jsonObject["dateCreated"] as? Double
        else { return nil }
        
        var importancy: Importancy = Importancy.common
        if let rightcase = Importancy(rawValue: importancyString){
            importancy = rightcase
        }
        
        var deadline: Date?
        if let deadlineDouble = jsonObject["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedDouble)
        
        var dateModified: Date?
        if let dateModifiedDouble = jsonObject["dateModified"] as? Double {
            dateModified = Date(timeIntervalSince1970: dateModifiedDouble)
        }

        return TodoItem(
            id: id,
            text: text,
            importancy: importancy,
            deadline: deadline,
            isComplited: isCompleted,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
    }
    
    // Формирования json
    var json: Any {
        var jsonDict: [String: Any] = [:]
        jsonDict["id"] = id
        jsonDict["text"] = text
        if importancy != .common { jsonDict["importancy"] = importancy.rawValue }
        if deadline != nil { jsonDict["deadline"] = deadline}
        jsonDict["isComplited"] = isComplited
        jsonDict["dateCreated"] = dateCreated.timeIntervalSince1970
        jsonDict["dateModified"] = dateCreated.timeIntervalSince1970
        return jsonDict
    }

}

