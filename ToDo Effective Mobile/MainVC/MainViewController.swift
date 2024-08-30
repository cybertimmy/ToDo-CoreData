import UIKit

final class MainViewController: UIViewController {
    
    private let mainView: MainView
    
    init() {
        self.mainView = MainView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
        setupTitleVC()
        setupNavigationBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavigationBarButton() {
        let button = UIBarButtonItem(title: "My ToDo", style: .plain, target: self, action: #selector(goScreenToDo))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupTitleVC() {
        navigationItem.title = "Json ToDo"
    }
}

extension MainViewController {
    @objc private func goScreenToDo() {
        navigationController?.pushViewController(ToDoViewContoller(), animated: true)
    }
}
