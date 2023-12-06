import UIKit

final class GroupsViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    private let wordService = WordService()
    private var groups: [VocabularyGroup] = []
    private var alertPresenter: AlertPresenter?
    
    private lazy var groupTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(resource: .whiteDN)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.rowHeight = 50
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellTableView.self, forCellReuseIdentifier: CellTableView.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.backgroundColor = .lightGray.withAlphaComponent(0.5)
        activityIndicator.color = .whiteDN
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        setupView()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        loadGroups()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(resource: .whiteDN)
        navigationItem.title = "Choose a group of words"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN)]
        navigationItem.hidesBackButton = true
        view.addSubview(activityIndicator)
        view.addSubview(groupTableView)
        NSLayoutConstraint.activate([
            groupTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            groupTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            groupTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadGroups() {
        wordService.getGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groups):
                self.groups = groups
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.groupTableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    private func tapGroup(_ group: VocabularyGroup) {
        let greekWordViewController = GreekWordViewController(group: group)
        navigationController?.pushViewController(greekWordViewController, animated: true)
    }
    
    private func showAlert() {
        let model = AlertModel(title: nil,
                               message: "Error data loading",
                               button1Text: "Retry",
                               completion1: { [weak self] in
            self?.loadGroups()
        })
        alertPresenter?.showErrorAlert(model: model)
    }
}

extension GroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellTableView.reuseIdentifier, for: indexPath)
        cell.tintColor = UIColor(resource: .blackDN)
        guard let groupCell = cell as? CellTableView else { return UITableViewCell() }
        let group = groups[indexPath.row]
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == groups.count - 1
        let isSelected = indexPath == selectedIndexPath
        groupCell.configure(with: group.name, isFirstRow: isFirstRow, isLastRow: isLastRow, isSelected: isSelected)
        return groupCell
    }
}

extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath.flatMap { tableView.cellForRow(at: $0) }?.accessoryType = .none
        selectedIndexPath = indexPath
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tapGroup(groups[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
