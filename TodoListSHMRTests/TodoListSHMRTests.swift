//
//  TodoListSHMRTests.swift
//  TodoListSHMRTests
//
//  Created by Ilya Ovchinnikov on 09.06.2023.
//

import XCTest
@testable import TodoListSHMR

final class TodoListSHMRTests: XCTestCase {

    func testToDoItemParseJSON1() throws {
        let j: [String: Any] = ["id": "12345",
                                "text": "Сделать домашнее задание",
                                "importancy": "important",
                                "deadline": 2022.0,
                                "isComplited": false,
                                "dateCreated": 2022.0,
                                "dateModified": 2022.0]
        
        let id = "12345";
        let text = "Сделать домашнее задание";
        let isComplited = false;
        let importancy: Importancy = .important
        let deadline = Date(timeIntervalSince1970: 2022.0)
        let dateCreated = Date(timeIntervalSince1970: 2022.0)
        let dateModified = Date(timeIntervalSince1970: 2022.0)
        
        let item: TodoItem = TodoItem.parse(json: j)!
    
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importancy, importancy)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.isComplited, isComplited)
        XCTAssertEqual(item.dateCreated, dateCreated)
        XCTAssertEqual(item.dateModified, dateModified)
    }

}
