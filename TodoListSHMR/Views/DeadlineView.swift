//
//  DeadlineView.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 21.06.2023.
//

import UIKit

class DeadlineView: UIView {
    
    //Надо отслеживать данные
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var stackView = UIStackView()
    var switchButton = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addSubview(stackView)
        addSubview(switchButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        titleLabel.text = "Сделать до"
        titleLabel.font = UIFont.systemFont(ofSize: constants.bodySize)
        titleLabel.textColor = Colors.labelPrimary.color
        
        subTitleLabel.text = "дата"
        subTitleLabel.font = UIFont.systemFont(ofSize: constants.footnoteSize)
        subTitleLabel.textColor = Colors.blue.color
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
//        switchButton.button.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        switchButton.backgroundColor = Colors.supportOverlay.color
        switchButton.layer.cornerRadius = constants.cornerRadius
    }
    
    func setupConstraints() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension DeadlineView {

    @objc func valueChanged(switcher: UISwitch) {
    //        valueDidChange?(switcher.isOn)
    }
    
}



