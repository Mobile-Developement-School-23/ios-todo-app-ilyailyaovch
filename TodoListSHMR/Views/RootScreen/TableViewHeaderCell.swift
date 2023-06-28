import UIKit

class TableViewHeaderCell: UITableViewHeaderFooterView {
    
    var valueDidChange: (() -> Void)?

    static let identifier: String = "TableViewHeaderCell"

    let textView = UILabel()
    let buttonView = UIButton()
    var counter = 0

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(){
        setupCounter()
        setupText()
        setupButton()
        setupContentView()
        setupContents()
    }

    func setupCounter(){
        counter = rootViewModel.fileCache.todoItems.filter( {$0.isCompleted} ).count
    }

    func setupText(){
        textView.textColor = Colors.labelTertiary.color
        textView.text = "Выполнено - \(counter)"
    }
    
    func setupButton(){
        buttonView.setTitle("Показать", for: .normal)
        buttonView.setTitle("Скрыть", for: .selected)
        buttonView.setTitleColor(.systemBlue, for: .normal)
        buttonView.addTarget(self, action: #selector(pressedButtonHeader), for: .touchUpInside)
    }
    
    func setupContentView(){
        contentView.backgroundColor = Colors.backPrimary.color
        contentView.addSubview(textView)
        contentView.addSubview(buttonView)
    }
    
    func setupContents() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            buttonView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension TableViewHeaderCell {
    
    @objc func pressedButtonHeader(_ button: UIButton) {
        print(button.isSelected)
        if button.isSelected {
            buttonView.isSelected = false
            self.valueDidChange?()
            rootViewModel.addCompletedToPresentation()
            rootViewModel.viewController?.updateData()
        } else {
            buttonView.isSelected = true
            self.valueDidChange?()
            rootViewModel.removeCompletedToPresentation()
        }
    }
}

