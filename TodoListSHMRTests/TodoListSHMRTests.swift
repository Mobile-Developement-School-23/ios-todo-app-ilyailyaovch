//
//  TodoListSHMRTests.swift
//  TodoListSHMRTests
//
//  Created by Ilya Ovchinnikov on 09.06.2023.
//

import XCTest
@testable import TodoListSHMR

final class TodoListSHMRTests: XCTestCase {

    func testTodoItemInit1(){
        
        let item1: TodoItem = TodoItem(
            text: "Lol",
            importancy: .important,
            dateCreated: Date(timeIntervalSince1970: 2023.0)
        )
        
        let text = "Lol"
        let importancy = Importancy.important
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
        
        XCTAssertNotNil(item1.id)
        XCTAssertEqual(item1.text, text)
        XCTAssertEqual(item1.importancy, importancy)
        XCTAssertEqual(item1.dateCreated, dateCreated)
        XCTAssertNil(item1.deadline)
        XCTAssertNil(item1.dateModified)
    }
    
    func testTodoItemInit2(){
        
        let item2: TodoItem = TodoItem(
            id: "111111111122222",
            text: "text",
            importancy: .important,
            deadline: Date(timeIntervalSince1970: 2023.0),
            isCompleted: false,
            dateCreated: Date(timeIntervalSince1970: 2023.0),
            dateModified: nil
        )
        
        let id = "111111111122222"
        let text = "text"
        let importancy = Importancy.important
        let deadline = Date(timeIntervalSince1970: 2023.0)
        let dateCreated = Date(timeIntervalSince1970: 2023.0)
        
        XCTAssertEqual(item2.id, id)
        XCTAssertEqual(item2.text, text)
        XCTAssertEqual(item2.importancy, importancy)
        XCTAssertEqual(item2.deadline, deadline)
        XCTAssertEqual(item2.dateCreated, dateCreated)
        XCTAssertNil(item2.dateModified)
    }
}
