//
//  TodoViewController.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 19.06.2023.
//

import UIKit

final class TodoViewController: UIViewController, UIScrollViewDelegate {

    // Properties

    // Потом изменить
    // для конкретной модели
    var viewModel: TodoViewModel = TodoViewModel()
    
    var cancelButton = UIButton(configuration: .plain(), primaryAction: nil)
    var saveButton = UIButton(configuration: .plain(), primaryAction: nil)
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    
    var textView = UITextView()
    var detailsStack = UIStackView()
    var divider = UIView()
    var importancyView = ImportancyView()
    var deadlineView = DeadlineView()
    var calendarDivider = UIView()
    var calendarView = CalendarView()
    var deleteButton = UIButton()
    
    
    // Inits
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate

extension TodoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        activateButtons()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
}

// MARK: - Visual changes

extension TodoViewController {

    func showCalendar(with date: Date) {
        calendarView.datePicker.setDate(date, animated: false)
        calendarView.datePicker.layer.opacity = 1
        calendarDivider.layer.opacity = 1
        UIView.animate(withDuration: 0.25) {
            self.calendarView.datePicker.isHidden = false
            self.calendarView.isHidden = false
            self.calendarDivider.isHidden = false
        }
    }

    func dismissCalendar() {
        calendarView.datePicker.layer.opacity = 0
        calendarDivider.layer.opacity = 0
        UIView.animate(withDuration: 0.25) {
            self.calendarView.datePicker.isHidden = true
            self.calendarView.isHidden = true
            self.calendarDivider.isHidden = true
        }
    }
    
    
    func importancyDidChange(importancy: Importancy){
        activateButtons()
    }
    
    func deadlineDidChange(isEnabled: Bool){
        let defaultDeadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        deadlineView.deadline = isEnabled ? deadlineView.deadline ?? defaultDeadline : nil
        isEnabled ? showCalendar(with: deadlineView.deadline ?? defaultDeadline) : dismissCalendar()
        activateButtons()
    }
    
    func deadlineSubTextDidClick(){
        if deadlineView.deadline != nil{
            let defaultDeadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            showCalendar(with: deadlineView.deadline ?? defaultDeadline)
        }
    }
    
    func deadlineDateDidChange(){
        deadlineView.deadline = calendarView.datePicker.date
        dismissCalendar()
    }

    
    func activateButtons(){
        if !textView.text.isEmpty && textView.text != constants.placeholder{
            saveButton.isEnabled = true
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(Colors.red.color, for: .normal)
        }
    }

}

// MARK: - @objc
extension TodoViewController {
    
    @objc func cancelButtonTap() {
        dismiss(animated: true)
    }

    @objc func saveButtonTap() {
        viewModel.saveItem(
            item: TodoItem(
                text: textView.text,
                importancy: importancyView.importancy ?? .normal,
                deadline: deadlineView.deadline ?? nil)
            )
    }
    
    @objc func deleteButtonTap() {
        if saveButton.isEnabled{
            viewModel.deleteItem(id: viewModel.state.id)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
}


