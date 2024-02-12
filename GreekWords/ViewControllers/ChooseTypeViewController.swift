import UIKit

final class ChooseTypeViewController: UIViewController {
    
    private let wordService = WordService()
    private var groups: [VocabularyGroup] = []
    private var vocabulary: Vocabulary?
    
    private lazy var fisrtButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Random selection", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(tapRandomSelection), for: .touchUpInside)
        return button
    }()
    
    private lazy var secondButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Words by groups", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(tapGroupSelection), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fisrtButton, secondButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .whiteDN)
        label.textAlignment = .center
        label.text = "Word of the day"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var emodjiImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "pencil.and.scribble") {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.lightGray
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emodjiImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var grWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .greyDN)
        label.textAlignment = .center
        label.text = "ο αριθμό"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var enWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .greyDN)
        label.textAlignment = .center
        label.text = "number"
        label.font = UIFont.italicSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [grWordLabel, enWordLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 12
        stackView.layer.backgroundColor = UIColor(resource: .greyDN).cgColor
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(resource: .whiteDN)
        navigationItem.title = "Word selection"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN)]
        navigationController?.navigationBar.tintColor = UIColor(resource: .blackDN)
        navigationItem.hidesBackButton = true
        [buttonsStackView, titleStackView, wordStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 150),
            titleStackView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 60),
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emodjiImageView.heightAnchor.constraint(equalToConstant: 50),
            emodjiImageView.widthAnchor.constraint(equalToConstant: 50),
            wordStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            wordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            wordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc
    private func tapGroupSelection() {
        let groupsViewController = GroupsViewController()
        navigationController?.pushViewController(groupsViewController, animated: true)
    }
    
    @objc func tapRandomSelection() {
        let randomWordsViewController = GreekWordViewController(group: nil)
        navigationController?.pushViewController(randomWordsViewController, animated: true)
    }
}
