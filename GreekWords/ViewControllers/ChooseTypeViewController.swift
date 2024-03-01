import UIKit
import GoogleMobileAds

final class ChooseTypeViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var bannerView: GADBannerView!
    private let wordService = WordService()
    private var article = ""
    private var greekWord = ""
    private var dayOfMonth: Int = 0
    private var labelArray: [UILabel] = []
    private var lastLabelValue: String?
    
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
        label.backgroundColor = .clear
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
        label.backgroundColor = UIColor(resource: .whiteDN)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enWordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .whiteDN)
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var wordContainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .whiteDN)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var letterLabel: WordLabel = {
        let label = WordLabel()
        return label
    }()
    
    private lazy var letterStackView: UIStackView = {
        let letterStackView = UIStackView()
        letterStackView.axis = .horizontal
        letterStackView.distribution = .fillEqually
        letterStackView.spacing = 3
        return letterStackView
    }()
    
    private lazy var letterButton: LetterButton = {
        let button = LetterButton()
        return button
    }()
    
    private lazy var letterButtonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 2
        return buttonStackView
    }()
    
    private lazy var backButton: OptionButton = {
        let button = OptionButton()
        let deleteImage = UIImage(systemName: "delete.backward")?.withRenderingMode(.alwaysTemplate)
        button.setImage(deleteImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var helpButton: OptionButton = {
        let button = OptionButton()
        let helpImage = UIImage(systemName: "questionmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(helpImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  Help", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        button.addTarget(self, action: #selector(tapHelpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var okButton: OptionButton = {
        let button = OptionButton()
        let okImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(okImage, for: .normal)
        button.tintColor = .lightGray
        button.setTitle("  OK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(tapOkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var articleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private lazy var helpEnLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
        view.backgroundColor = UIColor(resource: .greyDN)
        navigationItem.title = "Greek Words A1"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN)]
        navigationController?.navigationBar.tintColor = UIColor(resource: .blackDN)
        navigationItem.hidesBackButton = true
        [buttonsStackView, titleLabel, emodjiImageView, wordContainView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
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
    
    // MARK: - Word of the day
    
    private func setWordForCurrentDate() {
        let calendar = Calendar.current
        dayOfMonth = calendar.component(.day, from: Date())
        wordService.loadWordDay { result in
            switch result {
            case .success(let vocabularyWordDay):
                DispatchQueue.main.async {
                    let validIndex = max(0, min(self.dayOfMonth - 1, vocabularyWordDay.vocabulary.words.count - 1))
                    self.grWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].gr
                    self.enWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].en
                    if let lastPlayedDateString = UserDefaults.standard.string(forKey: "lastPlayedDate"),
                       let lastPlayedDate = self.dateFormatter.date(from: lastPlayedDateString),
                       calendar.isDateInToday(lastPlayedDate) {
                        self.wordContainView.isHidden = false
                    } else {
                        self.wordContainView.isHidden = true
                        self.processWordDay(vocabularyWordDay.vocabulary.words[validIndex].gr)
                        self.checkOkButton()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func processWordDay(_ originalWord: String) {
        let components = originalWord.components(separatedBy: " ")
        var shuffledDayWord = ""
        if let firstPart = components.first, let secondPart = components.last {
            let shuffledCharacters = secondPart.shuffled()
            shuffledDayWord = String(shuffledCharacters)
            article = firstPart
            greekWord = secondPart
        } else {
            let shuffledCharacters = originalWord.shuffled()
            shuffledDayWord = String(shuffledCharacters)
            greekWord = originalWord
        }
        addLetterStackView(shuffledDayWord)
        addLetterButtonStackView(shuffledDayWord)
    }
    
    private func addLetterStackView(_ shuffledDayWord: String) {
        letterStackView.subviews.forEach { $0.removeFromSuperview() }
        for char in shuffledDayWord {
            let letterLabel = WordLabel()
            labelArray.append(letterLabel)
            letterStackView.addArrangedSubview(letterLabel)
        }
        [letterStackView, backButton, helpButton, articleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            letterStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45),
            letterStackView.heightAnchor.constraint(equalToConstant: 44),
            letterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            letterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backButton.topAnchor.constraint(equalTo: letterStackView.bottomAnchor, constant: 10),
            backButton.trailingAnchor.constraint(equalTo: letterStackView.trailingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            helpButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            helpButton.leadingAnchor.constraint(equalTo: letterStackView.leadingAnchor),
            helpButton.widthAnchor.constraint(equalToConstant: 100),
            helpButton.heightAnchor.constraint(equalToConstant: 30),
            articleLabel.bottomAnchor.constraint(equalTo: letterStackView.topAnchor, constant: -5),
            articleLabel.leadingAnchor.constraint(equalTo: letterStackView.leadingAnchor)
        ])
    }
    
    private func addLetterButtonStackView(_ shuffledDayWord: String) {
        letterButtonStackView.subviews.forEach { $0.removeFromSuperview() }
        for char in shuffledDayWord {
            let letterButton = LetterButton()
            letterButton.setTitle(String(char), for: .normal)
            letterButton.addTarget(self, action: #selector(letterButtonTapped(_:)), for: .touchUpInside)
            letterButtonStackView.addArrangedSubview(letterButton)
        }
        letterButtonStackView.isUserInteractionEnabled = true
        [letterButtonStackView, okButton, helpEnLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            letterButtonStackView.topAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: 30),
            letterButtonStackView.heightAnchor.constraint(equalToConstant: 45),
            letterButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            letterButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            okButton.topAnchor.constraint(equalTo: letterButtonStackView.bottomAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: letterButtonStackView.trailingAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.heightAnchor.constraint(equalToConstant: 30),
            helpEnLabel.leadingAnchor.constraint(equalTo: letterButtonStackView.leadingAnchor),
            helpEnLabel.topAnchor.constraint(equalTo: letterButtonStackView.bottomAnchor, constant: 5)
        ])
    }
    
    private func addTextToLabels(_ text: String) {
        guard let nextLabel = self.labelArray.first(where: { $0.text == "" }) else {
            return
        }
        nextLabel.text = text
        self.view.layoutIfNeeded()
    }
    
    private func checkOkButton() {
        okButton.isEnabled = !labelArray.contains { $0.text == "" }
    }
    
    private func clearLabels() {
        for label in labelArray {
            label.text = ""
        }
    }
    
    private func enableLetterButtons() {
        for button in letterButtonStackView.arrangedSubviews {
            guard let letterButton = button as? LetterButton else {
                continue
            }
            letterButton.isEnabled = true
            letterButton.setTitleColor(.blackDN, for: .normal)
        }
    }
    
    private func hideGame() {
        letterStackView.isHidden = true
        letterButtonStackView.isHidden = true
        okButton.isHidden = true
        helpEnLabel.isHidden = true
        articleLabel.isHidden = true
        backButton.isHidden = true
        helpButton.isHidden = true
        wordContainView.isHidden = false
    }
    
    // MARK: - adMob method
    
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

    // MARK: - objc methods
    
    @objc
    private func tapGroupSelection() {
        let groupsViewController = GroupsViewController()
        navigationController?.pushViewController(groupsViewController, animated: true)
    }
    
    @objc
    private func tapRandomSelection() {
        let randomWordsViewController = GreekWordViewController(group: nil)
        navigationController?.pushViewController(randomWordsViewController, animated: true)
    }
    
    @objc
    private func letterButtonTapped(_ sender: LetterButton) {
        guard let tappedText = sender.title(for: .normal) else {
            return
        }
        addTextToLabels(tappedText)
        sender.isEnabled = false
        sender.setTitleColor(.lightGray, for: .normal)
        checkOkButton()
    }
    
    @objc
    private func tapHelpButton() {
        articleLabel.text = article
        articleLabel.isHidden = false
        helpEnLabel.text = enWordLabel.text
        helpEnLabel.isHidden = false
    }
    
    @objc
    private func tapBackButton() {
        guard let lastLabel = labelArray.last(where: { $0.text != nil && !$0.text!.isEmpty }) else {
            return
        }
        lastLabelValue = lastLabel.text
        lastLabel.text?.removeLast()
        for (index, button) in letterButtonStackView.arrangedSubviews.enumerated() {
            guard let letterButton = button as? LetterButton else {
                continue
            }
            if let titleColor = letterButton.titleColor(for: .normal), titleColor == .lightGray,
               letterButton.title(for: .normal) == lastLabelValue {
                letterButton.isEnabled = true
                letterButton.setTitleColor(.blackDN, for: .normal)
                break
            }
        }
        checkOkButton()
    }
    
    @objc
    private func tapOkButton() {
        let enteredWord = labelArray.compactMap { $0.text }.joined()
        let isCorrect = enteredWord == greekWord
        for label in labelArray {
            if isCorrect {
                label.layer.borderColor = UIColor.greenU.cgColor
                articleLabel.text = article
                articleLabel.isHidden = false
                helpEnLabel.text = enWordLabel.text
                helpEnLabel.isHidden = false
                let dateString = dateFormatter.string(from: Date())
                UserDefaults.standard.set(dateString, forKey: "lastPlayedDate")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    self.hideGame()
                }
            } else {
                label.layer.borderColor = UIColor.redU.cgColor
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    for label in self.labelArray {
                        label.layer.borderWidth = 1.0
                        label.layer.borderColor = UIColor.lightGray.cgColor
                    }
                    self.clearLabels()
                    self.enableLetterButtons()
                }
            }
        }
    }
    
    @objc
    private func appDidBecomeActive() {
        let calendar = Calendar.current
        let checkedDayOfMonth = calendar.component(.day, from: Date())
        if checkedDayOfMonth != dayOfMonth {
            setWordForCurrentDate()
        } else {
            return
        }
    }
}
