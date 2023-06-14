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
        id: "1111111111",
        text: "text",
        importancy: .important,
        isComplited: false,
        dateCreated: Date()
    )
    
    
    print("Item_1: ", item1.json)
    print("Item_2: " ,item2.json)
    
    var fileCash: FileCache = FileCache(fileName: "TestInput.json")
//    var fileCash2: FileCache = FileCache(fileName: "TestInput.json")
    do{
        try fileCash.add(item: item1)
        try fileCash.add(item: item2)
        try fileCash.remove(id: item1.id)
//        try fileCash.saveItems(to: "TestInput.json")
//        try fileCash2.loadItems(from: "TestInput.json")
    } catch {
        print ("error in add")
    }
    
    print(fileCash.todoItems)
//    print(fileCash2.todoItems)
    
}



