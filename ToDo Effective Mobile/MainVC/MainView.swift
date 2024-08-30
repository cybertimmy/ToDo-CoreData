import UIKit

final class MainView: UIView {
    
    private var tasks: [Todo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainCell.self, forCellReuseIdentifier: MainCell.identifer)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchTasks()
        setupTableView()
        setupApperiance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    private func setupApperiance() {
        self.addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.identifer, for: indexPath) as? MainCell else {
            fatalError()
        }
        let tasks = tasks[indexPath.row]
        cell.configure(task: tasks)
        return cell
    }
}

extension MainView {
    private func fetchTasks() {
        NetworkManager.shared.getData(url: .tasksURL, modelForParsing: Tasks.self) { [weak self] task in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let tasksResponce = task {
                    self.tasks = tasksResponce.todos
                } else {
                   fatalError()
                }
            }
        }
    }
}
