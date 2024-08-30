import UIKit

final class MainCell: UITableViewCell {
    
    static let identifer = "MainCell"
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 10
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupApperiance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupApperiance() {
        self.addSubviews(taskLabel,idLabel,checkmarkImageView)
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            taskLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            taskLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            taskLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            checkmarkImageView.trailingAnchor.constraint(equalTo: taskLabel.trailingAnchor, constant: 15),
            checkmarkImageView.topAnchor.constraint(equalTo: taskLabel.topAnchor),
            idLabel.topAnchor.constraint(equalTo: taskLabel.topAnchor),
            idLabel.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor, constant: -30),
        ])
    }
    
    func configure(task: Todo) {
        taskLabel.text = task.todo
        idLabel.text = String(task.id)
        let checkmarkImage = task.completed ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkmarkImageView.image = checkmarkImage
    }
}
