import UIKit

class GreekWordViewController: UIViewController {
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        view.addSubview(wordLabel)
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            wordLabel.heightAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
}
