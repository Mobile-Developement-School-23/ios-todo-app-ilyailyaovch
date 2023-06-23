//
//  Icons.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

enum Icon: String {
    case Low = "Low"
    case Important = "Important"
    
    var image: UIImage? {return UIImage(named: rawValue)}
}
