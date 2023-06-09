//
//  TodoItem.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 09.06.2023.
//

import Foundation

/*
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
         dateCreated: Date,
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

extension TodoItem {

    static func parse(json: Any) -> TodoItem?{
        
        guard let jsonObject = json as? [String: Any] else { return nil }
        
        guard
            let id = jsonObject["id"] as? String,
            let text = jsonObject["text"] as? String
        else { return nil }
        
        var importance = Importancy(rawValue: jsonObject["importance"] as? String ?? "common")
        
        return TodoItem()
    }

}
