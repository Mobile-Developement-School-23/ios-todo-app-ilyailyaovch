//
//  TestFunction.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 10.06.2023.
//

import Foundation

func testFunction () {
    
    //
    var item1: TodoItem = TodoItem(
        text: "Lol",
        importancy: .important
    )
    
    //
    var item2: TodoItem = TodoItem(
        id: "111111111122222",
        text: "text",
        importancy: .important,
        isComplited: false,
        dateCreated: Date()
    )

    
//    print("Item_1: ", item1.json)
//    print("Item_2: " ,item2.json)
    
//    var fileCash: FileCache = FileCache(fileName: "TestInput.json")
//    var fileCash2: FileCache = FileCache(fileName: "TestInput.json")
    var fileCash: FileCache = FileCache(fileName: "TestInput.csv")
    var fileCash2: FileCache = FileCache(fileName: "TestInput.csv")
    do{
        try fileCash.add(item: item1)
        try fileCash.add(item: item2)
//        try fileCash.remove(id: item1.id)
//        try fileCash.saveItems(to: "TestInput.json")
//        try fileCash2.loadItems(from: "TestInput.json")
        try fileCash.saveItemsCSV(to: fileCash.getFileName())
        try fileCash2.loadItemsCSV(from: "TestInput.csv")
    } catch {
        print ("error in add")
    }
    
    print(fileCash.todoItems)
    print(fileCash2.todoItems)
    
}



