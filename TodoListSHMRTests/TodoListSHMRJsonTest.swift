//
//  TodoListSHMRJsonTest.swift
//  TodoListSHMRTests
//
//  Created by Ilya Ovchinnikov on 17.06.2023.
//

import XCTest
@testable import TodoListSHMR

final class TodoListSHMRJsonTest: XCTestCase {

    func testToDoItemParseJSON1() throws {
        let json: [String: Any] = ["id": "12345",
                                "text": "qwe",
                                "importancy": "important",
                                "deadline": 2023.0,
                                "isCompleted": false,
                                "dateCreated": 2023.0,
                                "dateModified": 2023.0]
        
        let id = "12345";
        let text = "qwe";
        let isCompleted = false;
        let importancy: Importancy = .important
        let deadline = Date(timeIntervalSince1970: 2023.0)
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
        let dateModified = Date(timeIntervalSince1970: 2023.0)
        
        let item: TodoItem = TodoItem.parse(json: json)!
    
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importancy, importancy)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.dateCreated, dateCreated)
        XCTAssertEqual(item.dateModified, dateModified)
    }
    
    func testToDoItemParseJSON2() throws {
        let j: [String: Any] = ["id": "12345",
                                "text": "qwe",
                                "importancy": "normal",
                                "isCompleted": false,
                                "dateCreated": 2023.0]
        
        let id = "12345";
        let text = "qwe";
        let isCompleted = false;
        let importancy: Importancy = .normal
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
        
        let item = TodoItem.parse(json: j)
    
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.text, text)
        XCTAssertEqual(item?.importancy, importancy)
        XCTAssertNil(item?.deadline)
        XCTAssertEqual(item?.isCompleted, isCompleted)
        XCTAssertEqual(item?.dateCreated, dateCreated)
        XCTAssertNil(item?.dateModified)
    }
    
    func testToDoItemParseJSON3() throws {
        let j: [String: Any] = ["text": "qwe",
                                "importancy": "normal",
                                "isCompleted": false,
                                "dateCreated": 2023.0]

        let item = TodoItem.parse(json: j)
    
        XCTAssertNil(item)
    }
    
    func testToDoItemSaveLoadJSON1() throws {
        
        let item1: TodoItem = TodoItem(
            text: "Lol",
            importancy: .important,
            dateCreated: Date(timeIntervalSince1970: 2023.0)
        )
        
        let item2: TodoItem = TodoItem(
            id: "111111111122222",
            text: "text",
            importancy: .important,
            deadline: Date(timeIntervalSince1970: 2023.0),
            isCompleted: false,
            dateCreated: Date(timeIntervalSince1970: 2023.0),
            dateModified: nil
        )
        
        let fileCash: FileCache = FileCache(fileName: "TestInput")
        let fileCash2: FileCache = FileCache(fileName: "TestInput")
        
        try fileCash.add(item: item1)
        try fileCash.add(item: item2)
        try fileCash.remove(id: item1.id)
        try fileCash.saveItems(to: "TestInput")
        try fileCash2.loadItems(from: "TestInput")
    
        XCTAssertEqual(fileCash.todoItems[0].id, item2.id)
        XCTAssertEqual(fileCash2.todoItems[0].id, item2.id)
        XCTAssertEqual(fileCash.todoItems.count, 1)
        XCTAssertEqual(fileCash2.todoItems.count, 1)
    }

}
