//
//  ImportancyView.swift
//  TodoListSHMR
//
//  Created by Ilya Ovchinnikov on 20.06.2023.
//

import UIKit

class ImportancyView: UIView {
    
    //Надо отслеживать данные
    
    let titleLabel = UILabel()
    let segControl = UISegmentedControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addSubview(titleLabel)
        addSubview(segControl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        titleLabel.text = "Важность"
        titleLabel.font = UIFont.systemFont(ofSize: constants.bodySize)
        titleLabel.textColor = Colors.labelPrimary.color
        
        segControl.insertSegment(with: Icon.Low.image, at: 0, animated: false)
        segControl.insertSegment(withTitle: "нет", at: 1, animated: false)
        segControl.insertSegment(with: Icon.Important.image, at: 2, animated: false)
        segControl.selectedSegmentIndex = 1
        segControl.backgroundColor = Colors.supportOverlay.color
        segControl.selectedSegmentTintColor = Colors.backElevated.color

        segControl.addTarget(self, action: #selector(segControlValueChanged), for: .valueChanged)
        segControl.addTarget(self, action: #selector(segControlValueChanged), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            segControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            segControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            segControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            segControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            segControl.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

extension ImportancyView {
    
    @objc func segControlValueChanged(_ sender: UISegmentedControl) {
        print("Item Changed")
    }
}
