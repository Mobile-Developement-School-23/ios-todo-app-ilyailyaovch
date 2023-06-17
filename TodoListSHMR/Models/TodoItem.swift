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
    case normal
    case low
}

struct TodoItem {
    
    let id:             String
    let text:           String
    let importancy:     Importancy
    let deadline:       Date?
    let isCompleted:    Bool
    let dateCreated:    Date
    let dateModified:   Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importancy: Importancy = Importancy.normal,
         deadline: Date? = nil,
         isCompleted: Bool = false,
         dateCreated: Date = Date(),
         dateModified: Date? = nil) {
        self.id = id
        self.text = text
        self.importancy = importancy
        self.deadline = deadline
        self.isCompleted = isCompleted
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
            let isCompleted = jsonObject["isCompleted"] as? Bool,
            let dateCreatedDouble = jsonObject["dateCreated"] as? Double
        else { return nil }
        
        var importancy: Importancy = Importancy.normal
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
            isCompleted: isCompleted,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
    }
    
    // Формирования json
    var json: Any {
        var jsonDict: [String: Any] = [:]
        jsonDict["id"] = self.id
        jsonDict["text"] = self.text
        if importancy != .normal { jsonDict["importancy"] = importancy.rawValue }
        if let deadline = self.deadline { jsonDict["deadline"] = Int(deadline.timeIntervalSince1970)}
        jsonDict["isCompleted"] = self.isCompleted
        jsonDict["dateCreated"] = Int(dateCreated.timeIntervalSince1970)
        if let dateModified = self.dateModified { jsonDict["dateModified"] = Int(dateModified.timeIntervalSince1970)}
        return jsonDict
    }
}

/* TodoItem, parsing csv
〉Реализовать расширение TodoItem для разбора формата СSV
〉Содержит функцию (static func parse(csv: String) -> TodoItem?) для разбора CSV
〉Содержит вычислимое свойство (var csv: String) для формирования CSV
〉Не сохранять в csv важность, если она "обычная"
〉Не сохранять в csv сложные объекты (Date), переводить в более простой формат
〉Сохранять deadline только если он задан
 */

extension TodoItem {
 
    // Разбор csv
    static func parse(csv: String) -> TodoItem?{
        
        let csvArr : [String] = csv.components(separatedBy: ";")
        
        let id = csvArr[0]
        if id == "" { return nil }
        
        let text = csvArr[1]
        if text == "" { return nil }
        
        let importancyString = csvArr[2]
        var importancy: Importancy = Importancy.normal
        if let rightcase = Importancy(rawValue: importancyString){
            importancy = rightcase
        }
        
        var deadline: Date?
        let deadlineString = csvArr[3]
        if let deadlineDouble = Double(deadlineString){
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }
        
        guard
            let isCompleted = Bool(String(csvArr[4]))
        else {return nil}
        
        guard
            let dateCreatedDouble = Double(csvArr[5])
        else {return nil}
        let dateCreated = Date(timeIntervalSince1970: dateCreatedDouble)
        
        var dateModified: Date?
        let dateModifiedString = String(csvArr[6])
        if let dateModifiedDouble = Double(dateModifiedString){
            dateModified = Date(timeIntervalSince1970: dateModifiedDouble)
        }

        return TodoItem(
            id: id,
            text: text,
            importancy: importancy,
            deadline: deadline,
            isCompleted: isCompleted,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
    }
    
    // Формирования csv
    var csv: String {
        var csvString: String = ""
        csvString.append(self.id + ";")
        csvString.append(self.text + ";")
        csvString.append(self.importancy == .normal ? "" : self.importancy.rawValue)
        csvString.append(";")
        csvString.append(self.deadline != nil ?
                         "\(String(describing: self.deadline?.timeIntervalSince1970))" : "")
        csvString.append(";")
        csvString.append(String(self.isCompleted))
        csvString.append(";")
        csvString.append("\(String(describing: self.dateCreated.timeIntervalSince1970))")
        csvString.append(";")
        csvString.append(self.dateModified != nil ?
                         "\(String(describing: self.dateModified?.timeIntervalSince1970))" : "")
        csvString.append("\n")
        return csvString
    }
}
