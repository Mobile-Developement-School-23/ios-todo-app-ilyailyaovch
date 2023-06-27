import UIKit

final class TableViewCell: UITableViewCell {

    var circleStatViewTapped: (() -> Void)?

    static let identifier: String = "TableViewCell"

    let textView = UILabel()
    // deadlineView?
    let stackView = UIStackView()
    //circleStatView
    //importancyStatView
    let shevronView = UIImageView(image: Icon.Shevron.image)
    
    // MARK: - Override init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        //addCellTapRecogniser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configureCell
    
    func configureCell(with item: TodoItem){
        
        textView.text = item.text
        
        //importancy
        //deadline
        //isCompleted
    }
    
    // MARK: - setupViews
    
    func setupViews(){
        contentView.backgroundColor = Colors.backSecondary.color
        setupTextView()
        setupStackView()
        
        contentView.addSubview(stackView)
        contentView.addSubview(shevronView)
        
        stackView.addArrangedSubview(textView)
    }
    
    func setupStackView(){
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
    }
    
    func setupTextView(){
        textView.numberOfLines = 3
        textView.textColor = Colors.labelPrimary.color
    }
    
    // MARK: - setupConstraints
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        shevronView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            shevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shevronView.widthAnchor.constraint(equalToConstant: 7),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // MARK: Потом изменить!!!
            stackView.trailingAnchor.constraint(equalTo: shevronView.leadingAnchor, constant: -16)
            
        ])
    }
    
}
