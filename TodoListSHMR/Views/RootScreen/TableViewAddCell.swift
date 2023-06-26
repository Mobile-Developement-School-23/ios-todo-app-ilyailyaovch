import UIKit

final class TableViewAddCell: UITableViewCell, UITextFieldDelegate {

    var addCellTapped: (() -> Void)?

    static let identifier: String = "TableViewAddCell"

    let textField = UILabel()
    let imagePlus = UIImage(systemName: "plus.circle.fill")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupText()
        setupViews()
        setupConstraints()
        addCellTapRecogniser()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupText(){
        textField.text = "Новое"
        textField.textColor = Colors.labelTertiary.color
    }

    func setupViews() {
        contentView.backgroundColor = Colors.white.color
        contentView.addSubview(textField)
    }

    func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 + 24 + 12),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func addCellTapRecogniser(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAddCell))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tap)
        }
}

extension TableViewAddCell {

    @objc func clickAddCell(switcher: UISwitch) {
        addCellTapped?()
    }
}
