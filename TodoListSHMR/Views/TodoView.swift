//
//  TodoView.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 22.06.2023.
//

import UIKit

extension TodoViewController: TodoViewControllerProtocol{
    
    // MARK: - Override viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backPrimary.color

        setupNavigationBar()
        setupBody()
        setupBodyConstrains()
        setupKeyboardObserver()
        
        valuesDidChange()
    }
    
    // MARK: - Keyboard observer
    
    func setupKeyboardObserver() {

        NotificationCenter.default.addObserver(
            self,selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    // MARK: - Values Did Change

    func valuesDidChange(){
        
        importancyView.valueDidChange = { [weak self] value in
            self?.importancyDidChange(importancy: value)
        }
        
        deadlineView.valueDidChange = { [weak self] value in
            self?.deadlineDidChange(isEnabled: value)
        }
        
        deadlineView.deadlineDidClick = { [weak self] in
            self?.deadlineSubTextDidClick()
        }
        
        calendarView.valueDidChange = { [weak self] value in
            self?.deadlineDateDidChange()
        }
    }
    
    // MARK: - Setup NavigationBar

    func setupNavigationBar() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)

        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.isEnabled = false
    }
    
    //  MARK: - Setup TodoView
    
    func setupBody(){
        
        view.addSubview(scrollView)
        
        setupStackView()
        scrollView.addSubview(stackView)
        
        setupTextView()
        stackView.addArrangedSubview(textView)
        
        setupDetailsStack()
        stackView.addArrangedSubview(detailsStack)
        
        setupDeleteButton()
        stackView.addArrangedSubview(deleteButton)
    }
    
    func setupScrollView(){
        scrollView.delegate = self
        scrollView.contentSize.width = 1
    }
    
    func setupStackView(){
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        stackView.alignment = .fill
    }
    
    func setupTextView(){
        textView.delegate = self
        textView.text = constants.placeholder
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = constants.cornerRadius
        textView.backgroundColor = Colors.backSecondary.color
        textView.font = UIFont.systemFont(ofSize: constants.bodySize)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isScrollEnabled = false
        textView.keyboardDismissMode = .interactive
    }
    
    func setupDivider(divider: UIView){
        let fill = UIView()
        divider.addSubview(fill)
        fill.backgroundColor = Colors.supportSeparator.color
        fill.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            fill.topAnchor.constraint(equalTo: divider.topAnchor),
            fill.leftAnchor.constraint(equalTo: divider.leftAnchor, constant: 16),
            fill.rightAnchor.constraint(equalTo: divider.rightAnchor, constant: -16),
            fill.heightAnchor.constraint(equalTo: divider.heightAnchor)
        ])
    }
    
    func setupDetailsStack(){
        detailsStack.axis = .vertical
        detailsStack.alignment = .fill
        detailsStack.distribution = .equalSpacing
        detailsStack.layer.cornerRadius = constants.cornerRadius
        detailsStack.backgroundColor = Colors.backSecondary.color
        
        setupDivider(divider: divider)
        setupDivider(divider: calendarDivider)
                
        detailsStack.addArrangedSubview(importancyView)
        detailsStack.addArrangedSubview(divider)
        detailsStack.addArrangedSubview(deadlineView)
        detailsStack.addArrangedSubview(calendarDivider)
        detailsStack.addArrangedSubview(calendarView)
        calendarDivider.isHidden = true
        calendarView.isHidden = true
    }
    
    func setupDeleteButton(){
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.isEnabled = false
        deleteButton.setTitleColor(Colors.labelDisable.color, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: constants.bodySize)
        deleteButton.backgroundColor = Colors.backSecondary.color
        deleteButton.configuration?.contentInsets = .init(top: 17, leading: 16, bottom: 17, trailing: 16)
        deleteButton.layer.cornerRadius = constants.cornerRadius
        deleteButton.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Constrains of TodoItemsViewController
    
    func setupBodyConstrains(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            importancyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            deadlineView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
