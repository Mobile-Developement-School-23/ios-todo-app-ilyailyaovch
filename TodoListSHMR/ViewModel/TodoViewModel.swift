//
//  TodoViewModel.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 19.06.2023.
//

import UIKit

final class TodoViewModel {
    
    weak var viewController: TodoViewController?
    
    // ТУТ НУЖНО КАК-ТО СДЕЛАТЬ ЧТОБЫ viewController СТАЛ TodoViewController
    
    func writeHello(){
        print("Hello")
    }
    
}
