import UIKit
import GoogleMobileAds

final class ChooseTypeViewController: UIViewController {
    
    var bannerView: GADBannerView!
    private let wordService = WordService()
    
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
    
    private lazy var image: UIImage? = {
        if let systemImage = UIImage(systemName: "pencil.and.scribble") {
            return systemImage.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(resource: .dayWordIcon).withRenderingMode(.alwaysTemplate)
        }
    }()
    
    private lazy var emodjiImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = self.image {
            imageView.image = image
            imageView.tintColor = UIColor.lightGray
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var grWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .greyDN)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .greyDN)
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [grWordLabel, enWordLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.backgroundColor = UIColor(resource: .greyDN).cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var wordContainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .greyDN)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 12
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createWordContainView()
        setWordForCurrentDate()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-5556708431342690/1500663167"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(resource: .whiteDN)
        navigationItem.title = "Greek Words A1"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN)]
        navigationController?.navigationBar.tintColor = UIColor(resource: .blackDN)
        navigationItem.hidesBackButton = true
        [buttonsStackView, titleLabel, emodjiImageView, wordContainView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 150),
            titleLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emodjiImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            emodjiImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -20),
            emodjiImageView.heightAnchor.constraint(equalToConstant: 50),
            emodjiImageView.widthAnchor.constraint(equalToConstant: 50),
            wordContainView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            wordContainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            wordContainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            wordContainView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func createWordContainView() {
        wordContainView.addSubview(wordStackView)
        NSLayoutConstraint.activate([
            wordStackView.centerYAnchor.constraint(equalTo: wordContainView.centerYAnchor),
            wordStackView.centerXAnchor.constraint(equalTo: wordContainView.centerXAnchor),
        ])
    }
    
    private func setWordForCurrentDate() {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: Date())
        wordService.loadWordDay { result in
            switch result {
            case .success(let vocabularyWordDay):
                DispatchQueue.main.async {
                    let validIndex = max(0, min(dayOfMonth - 1, vocabularyWordDay.vocabulary.words.count - 1))
                    self.grWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].gr
                    self.enWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].en
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
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
