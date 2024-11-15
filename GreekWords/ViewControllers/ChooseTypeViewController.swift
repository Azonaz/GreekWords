import UIKit
import GoogleMobileAds

final class ChooseTypeViewController: UIViewController {
    var bannerView: GADBannerView!
    var gameManager: WordDayManager!

    lazy var grWordLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: isPad ? 32 : 20, weight: .regular))
        return label
    }()

    lazy var enWordLabel: UILabel = {
        let label = UILabel.customLabel(font: .italicSystemFont(ofSize: isPad ? 32 : 20))
        return label
    }()

    lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [grWordLabel, enWordLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var wordContainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .whiteDN)
        view.layer.cornerRadius = 16
        return view
    }()

    lazy var letterLabel: WordLabel = {
        let label = WordLabel()
        return label
    }()

    lazy var letterStackView: UIStackView = {
        let letterStackView = UIStackView()
        letterStackView.axis = .horizontal
        letterStackView.distribution = .fillEqually
        letterStackView.spacing = isPad ? 6 : 3
        return letterStackView
    }()

    lazy var letterButton: LetterButton = {
        let button = LetterButton()
        return button
    }()

    lazy var letterButtonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = isPad ? 4 : 2
        return buttonStackView
    }()

    lazy var backButton: OptionButton = {
        let button = OptionButton()
        let deleteImage = UIImage(systemName: "delete.backward")?.withRenderingMode(.alwaysTemplate)
        button.setImage(deleteImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 22 : 16, weight: .thin)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()

    lazy var helpButton: OptionButton = {
        let button = OptionButton()
        let helpImage = UIImage(systemName: "questionmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(helpImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  Help", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 22 : 16, weight: .thin)
        button.addTarget(self, action: #selector(tapHelpButton), for: .touchUpInside)
        return button
    }()

    lazy var okButton: OptionButton = {
        let button = OptionButton()
        let okImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(okImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  OK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 22 : 16, weight: .thin)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(tapOkButton), for: .touchUpInside)
        return button
    }()

    lazy var articleLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: isPad ? 24 : 18, weight: .regular),
                                        backgroundColor: .clear, textAlignment: .left)
        label.isHidden = true
        return label
    }()

    lazy var helpEnLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: isPad ? 24 : 18, weight: .regular),
                                        backgroundColor: .clear, textAlignment: .left)
        label.isHidden = true
        return label
    }()

    private lazy var firstButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Random selection", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 32 : 20, weight: .medium)
        button.addTarget(self, action: #selector(tapRandomSelection), for: .touchUpInside)
        return button
    }()

    private lazy var secondButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Words by groups", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 32 : 20, weight: .medium)
        button.addTarget(self, action: #selector(tapGroupSelection), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: isPad ? 32 : 20, weight: .semibold),
                                        backgroundColor: .clear)
        label.text = "Word of the day"
        return label
    }()

    private lazy var image: UIImage? = {
        if let systemImage = UIImage(systemName: "pencil.and.scribble") {
            return systemImage.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(resource: .dayWordIcon).withRenderingMode(.alwaysTemplate)
        }
    }()

    private lazy var emojiImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = self.image {
            imageView.image = image
            imageView.tintColor = UIColor.lightGray
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager = WordDayManager(viewController: self)
        setupView()
        gameManager.setWordForCurrentDate()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-5556708431342690/1500663167"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - adMob method
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([
            NSLayoutConstraint(item: bannerView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view.safeAreaLayoutGuide,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: bannerView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
        ])
    }

    // MARK: - objc methods
    @objc private func tapGroupSelection() {
        let groupsViewController = GroupsViewController()
        navigationController?.pushViewController(groupsViewController, animated: true)
    }

    @objc private func tapRandomSelection() {
        let randomWordsViewController = GreekWordViewController(group: nil)
        navigationController?.pushViewController(randomWordsViewController, animated: true)
    }

    @objc private func tapOkButton() {
        gameManager.tapOkButton()
    }

    @objc private func tapBackButton() {
        gameManager.tapBackButton()
    }

    @objc private func tapHelpButton() {
        gameManager.tapHelpButton()
    }

    @objc private func appDidBecomeActive() {
        let calendar = Calendar.current
        let checkedDayOfMonth = calendar.component(.day, from: Date())
        if checkedDayOfMonth != gameManager.dayOfMonth {
            gameManager.setWordForCurrentDate()
            articleLabel.isHidden = true
            helpEnLabel.isHidden = true
        }
    }
}

// MARK: - Creating UI
extension ChooseTypeViewController {
    private func setupView() {
        view.backgroundColor = UIColor(resource: .grayDN)
        navigationItem.title = "Greek Words A1"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: isPad ? 34 : 26, weight: .semibold)
        ]
        navigationController?.navigationBar.tintColor = UIColor(resource: .blackDN)
        navigationItem.hidesBackButton = true
        [buttonsStackView, titleLabel, emojiImageView, wordContainView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: isPad ? 160 : 120),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isPad ? 120 : 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isPad ? -120 : -60),
            buttonsStackView.heightAnchor.constraint(equalToConstant: isPad ? 180 : 150),
            titleLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: isPad ? 120 : 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            emojiImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20),
            emojiImageView.heightAnchor.constraint(equalToConstant: 50),
            emojiImageView.widthAnchor.constraint(equalToConstant: 50),
            wordContainView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: isPad ? 40 : 20),
            wordContainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isPad ? 90 : 40),
            wordContainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isPad ? -90 : -40),
            wordContainView.heightAnchor.constraint(equalToConstant: isPad ? 150 : 110)
        ])
        createWordContainView()
    }

    private func createWordContainView() {
        wordContainView.addSubview(wordStackView)
        NSLayoutConstraint.activate([
            wordStackView.centerYAnchor.constraint(equalTo: wordContainView.centerYAnchor),
            wordStackView.centerXAnchor.constraint(equalTo: wordContainView.centerXAnchor)
        ])
    }

    func createLabelView () {
        [letterStackView, backButton, helpButton, articleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            letterStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: isPad ? 55 : 45),
            letterStackView.heightAnchor.constraint(equalToConstant: isPad ? 64 : 44),
            letterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isPad ? 60 : 20),
            letterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isPad ? -60 : -20),
            backButton.topAnchor.constraint(equalTo: letterStackView.bottomAnchor, constant: isPad ? 20 : 10),
            backButton.trailingAnchor.constraint(equalTo: letterStackView.trailingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: isPad ? 130 : 100),
            backButton.heightAnchor.constraint(equalToConstant: isPad ? 40 : 30),
            helpButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            helpButton.leadingAnchor.constraint(equalTo: letterStackView.leadingAnchor),
            helpButton.widthAnchor.constraint(equalToConstant: isPad ? 130 : 100),
            helpButton.heightAnchor.constraint(equalToConstant: isPad ? 40 : 30),
            articleLabel.bottomAnchor.constraint(equalTo: letterStackView.topAnchor, constant: isPad ? -15 : -5),
            articleLabel.leadingAnchor.constraint(equalTo: letterStackView.leadingAnchor)
        ])
    }

    func createButtonView() {
        letterButtonStackView.isUserInteractionEnabled = true
        [letterButtonStackView, okButton, helpEnLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            letterButtonStackView.topAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: isPad ? 40 : 30),
            letterButtonStackView.heightAnchor.constraint(equalToConstant: isPad ? 65 : 45),
            letterButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isPad ? 60 : 20),
            letterButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isPad ? -60 : -20),
            okButton.topAnchor.constraint(equalTo: letterButtonStackView.bottomAnchor, constant: isPad ? 30 : 20),
            okButton.trailingAnchor.constraint(equalTo: letterButtonStackView.trailingAnchor),
            okButton.widthAnchor.constraint(equalToConstant: isPad ? 130 : 100),
            okButton.heightAnchor.constraint(equalToConstant: isPad ? 40 : 30),
            helpEnLabel.leadingAnchor.constraint(equalTo: letterButtonStackView.leadingAnchor),
            helpEnLabel.topAnchor.constraint(equalTo: letterButtonStackView.bottomAnchor, constant: isPad ? 15 : 5)
        ])
    }
}
