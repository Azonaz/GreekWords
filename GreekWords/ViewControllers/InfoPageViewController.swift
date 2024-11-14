import UIKit

final class InfoPageViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.logoA2
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.7
        return imageView
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: 20, weight: .regular))
        let text = "If you've already mastered Greek at the A1 level, take the next step! " +
                   "Download our new A2 app and keep building your Greek language skills."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: 1.2,
                .font: UIFont.systemFont(ofSize: 24, weight: .regular),
                .foregroundColor: UIColor.blackDN.withAlphaComponent(0.7)
            ]
        )
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()

    private lazy var closeButton: OptionButton = {
        let button = OptionButton()
        let closeImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeImage, for: .normal)
        button.tintColor = .blackDN.withAlphaComponent(0.7)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var goA2Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .logoAppSt), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.alpha = 0.5
        button.addTarget(self, action: #selector(tapGoA2Button), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .grayDN)
        setupUI()
    }

    private func setupUI() {
        [logoImageView, infoLabel, closeButton, goA2Button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            infoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            goA2Button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            goA2Button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            goA2Button.heightAnchor.constraint(equalToConstant: 80),
            goA2Button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }

    @objc private func tapCloseButton() {
        UserDefaults.standard.set(true, forKey: "didShowInfoScreen")
        let chooseTypeViewController = ChooseTypeViewController()
        let navigationController = UINavigationController(rootViewController: chooseTypeViewController)
        if let window = view.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            }, completion: nil)
        }
    }

    @objc private func tapGoA2Button() {
        if let url = URL(string: "https://apps.apple.com/cy/app/greek-words-a2/id6736978135") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
