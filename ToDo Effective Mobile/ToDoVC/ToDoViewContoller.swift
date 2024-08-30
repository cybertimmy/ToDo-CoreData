import UIKit

final class ToDoViewContoller: UIViewController {
        
    public var models = [ToDoListItem]()
    private let toDoView: ToDoView
    
    init() {
        self.toDoView = ToDoView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = toDoView
        setupTableView()
        getAllItems()
        setupNavigationBarButton()
        setupTitleVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTitleVC() {
        navigationItem.title = "ToDo"
    }
    
    private func setupNavigationBarButton() {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupTableView() {
        toDoView.tableView.delegate = self
        toDoView.tableView.dataSource = self
    }
    
    private func getAllItems() {
        ToDoModel.shared.getAllItems { [weak self] items in
            self?.models = items
            self?.toDoView.tableView.reloadData()
        }
    }
    
    private func createItem(name: String) {
        ToDoModel.shared.createItem(name: name) { [weak self] success in
            if success {
                self?.getAllItems()
            }
        }
    }
    
    private func deleteItem(item: ToDoListItem) {
        ToDoModel.shared.deleteItem(item: item) { [weak self] sucess in
            if sucess {
                self?.getAllItems()
            }
        }
    }
    
    private func updateItem(item: ToDoListItem, newName: String) {
        ToDoModel.shared.updateItem(item: item, newName: newName) { [weak self] sucess in
            if sucess {
                self?.getAllItems()
            }
        }
    }
    
    private func updateItemDescription(item: ToDoListItem, newDescription: String) {
        ToDoModel.shared.updateItemDescription(item: item, newDescription: newDescription) { [weak self] success in
            self?.getAllItems()
        }
    }
    
    private func createAttributedText(name: String, description: String, date: String) -> NSAttributedString {
        let nameAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        let descriptionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .light)]
    
        let nameAttributed = NSAttributedString(string: name, attributes: nameAttributes)
        let descriptionAttributed = NSAttributedString(string: "\n\(description)", attributes: descriptionAttributes)
        let dateAttributed = NSAttributedString(string: "\n\(date)", attributes: dateAttributes)
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(nameAttributed)
        combinedString.append(descriptionAttributed)
        combinedString.append(dateAttributed)
        
        return combinedString
    }
}

extension ToDoViewContoller {
    @objc private func addTask() {
        let alert = UIAlertController(title: "New Item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
}

extension ToDoViewContoller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identiferCell, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            let name = model.name ?? "No name"
            let description = model.descriptionTask ?? ""
            let creationDate = model.createdAt?.formattedDate() ?? "No date"
            cell.textLabel?.attributedText = createAttributedText(name: name, description: description, date: creationDate)
            cell.accessoryType = model.completed ? .checkmark : .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = models[indexPath.row]
        item.completed.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = models[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
             self?.deleteItem(item: item)
             completionHandler(true)
         }
        let editDescription = UIContextualAction(style: .normal, title: "Description") { [weak self] (_, _, completionHandler) in
            let alert = UIAlertController(title: "Description", message: "Add Description", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = item.descriptionTask
            }
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newDescription = field.text, !newDescription.isEmpty else {
                    return
                }
                self?.updateItemDescription(item: item, newDescription: newDescription)
            }))
            self?.present(alert, animated: true)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
                   let alert = UIAlertController(title: "Edit item", message: "Edit your Item", preferredStyle: .alert)
                   alert.addTextField(configurationHandler: nil)
                   alert.textFields?.first?.text = item.name
                   alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                       guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                           return
                       }
                       self?.updateItem(item: item, newName: newName)
                   }))
                   self?.present(alert, animated: true)
                   completionHandler(true)
               }
               editAction.backgroundColor = .blue
               let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction,editDescription])
               return configuration
    }
}
