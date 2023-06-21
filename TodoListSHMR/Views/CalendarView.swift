//
//  CalendarView.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 21.06.2023.
//

import UIKit

class CalendarView: UIView {
    
    //Надо отслеживать данные
    
    var datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalendarView()
        addSubview(datePicker)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCalendarView(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale.autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    func setupConstraints(){
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo:topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            datePicker.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}

extension CalendarView {
    
    @objc func datePickerChanged(_ sender: UISegmentedControl) {
        print("Item Changed")
    }

}
