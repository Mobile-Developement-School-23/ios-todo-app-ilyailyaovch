//
//  TodoListSHMRCsvTest.swift
//  TodoListSHMRTests
//
//  Created by Ilya Ovchinnikov on 17.06.2023.
//

import XCTest
@testable import TodoListSHMR

final class TodoListSHMRCsvTest: XCTestCase {

    func testToDoItemParseCSV1() throws {
        let j: String = "111222;Text here;important;2023.0;false;2023.0;2023.0"
        
        let id = "111222";
        let text = "Text here";
        let isCompleted = false;
        let importancy: Importancy = .important
        let deadline = Date(timeIntervalSince1970: 2023.0)
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
        let dateModified = Date(timeIntervalSince1970: 2023.0)
        
        let item: TodoItem = TodoItem.parse(csv: j)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importancy, importancy)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.dateCreated, dateCreated)
        XCTAssertEqual(item.dateModified, dateModified)
    }
    
    func testToDoItemParseCSV2() throws {
        let j: String = "111222;Text here;;;false;2023.0;"
        
        let id = "111222";
        let text = "Text here";
        let isCompleted = false;
        let importancy: Importancy = .normal
//        let deadline = Date(timeIntervalSince1970: 2023.0)
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
//        let dateModified = Date(timeIntervalSince1970: 2023.0)
        
        let item: TodoItem = TodoItem.parse(csv: j)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importancy, importancy)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.dateCreated, dateCreated)
        XCTAssertNil(item.dateModified)
    }

    func testToDoItemParseCSV3() throws {
        let j: String = ";Text here;;;false;2023.0;"

        let item = TodoItem.parse(csv: j)
    
        XCTAssertNil(item)
    }
    
    func testToDoItemSaveLoadCSV1() throws {
        
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
        try fileCash.saveItemsCSV(to: "TestInput")
        try fileCash2.loadItemsCSV(from: "TestInput")
    
        XCTAssertEqual(fileCash.todoItems[0].id, item2.id)
        XCTAssertEqual(fileCash2.todoItems[0].id, item2.id)
        XCTAssertEqual(fileCash2.todoItems[0].text, item2.text)
        XCTAssertEqual(fileCash2.todoItems[0].importancy, item2.importancy)
        XCTAssertEqual(fileCash2.todoItems[0].dateCreated, item2.dateCreated)
        XCTAssertEqual(fileCash.todoItems.count, 1)
        XCTAssertEqual(fileCash2.todoItems.count, 1)
    }
}
