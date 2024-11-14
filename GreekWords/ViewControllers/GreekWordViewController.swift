import UIKit

class GreekWordViewController: UIViewController {
    var selectedGroup: VocabularyGroup?
    private let wordService = WordService()
    private var alertPresenter: AlertPresenter?
    private var words: [Word] = []
    private var vocabulary: Vocabulary?
    private var currentRoundWords: [Word] = []
    private var correctWord: Word?
    private var questionsAsked = 0
    private var correctAnswers = 0
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: 26, weight: .bold))
        label.numberOfLines = 0
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: 20, weight: .regular), backgroundColor: .clear)
        label.text = "Select correct option"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel.customLabel(font: .systemFont(ofSize: 18, weight: .regular), backgroundColor: .clear)
        return label
    }()
    
    private lazy var firstButton: OptionButton = {
        let button = OptionButton()
        return button
    }()
    
    private lazy var secondButton: OptionButton = {
        let button = OptionButton()
        return button
    }()
    
    private lazy var thirdButton: OptionButton = {
        let button = OptionButton()
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    init(group: VocabularyGroup?) {
        self.selectedGroup = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        view.backgroundColor = UIColor(resource: .grayDN)
        setupView()
        getWords {
            self.updateWord()
            self.setupButtonActions()
        }
    }
    
    private func setupView() {
        if let selectedGroupName = selectedGroup?.name, !selectedGroupName.isEmpty {
            navigationItem.title = selectedGroupName
        } else {
            navigationItem.title = "Random words"
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .blackDN)]
        navigationController?.navigationBar.tintColor = UIColor(resource: .blackDN)
        [wordLabel, countLabel, infoLabel, buttonsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            wordLabel.heightAnchor.constraint(equalToConstant: 150),
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    private func getWords(completion: @escaping () -> Void) {
        if let selectedGroup = selectedGroup {
            words = wordService.getWords(for: selectedGroup)
            currentRoundWords = wordService.getRandomWords(for: selectedGroup, count: 10)
            completion()
        } else {
            wordService.getRandomWordsForAll(count: 10) { randomWords in
                self.currentRoundWords = randomWords
                self.words = randomWords
                completion()
            }
        }
    }
    
    private func setRandomWord() {
        if let randomWord = currentRoundWords.popLast() {
            wordLabel.text = randomWord.gr
            correctWord = randomWord
        }
    }
    
    private func setRandomValuesForWord() {
        guard let correctWord = correctWord?.gr else { return }
        var options = words.filter { $0.gr == correctWord }
        let remainingWords = words.filter { $0.gr != correctWord }
        options.append(contentsOf: remainingWords.shuffled().prefix(2))
        options.shuffle()
        firstButton.setTitle(options[0].en, for: .normal)
        secondButton.setTitle(options[1].en, for: .normal)
        thirdButton.setTitle(options[2].en, for: .normal)
    }
    
    private func updateWord() {
        setRandomWord()
        setRandomValuesForWord()
        questionsAsked += 1
        countLabel.text = "\(questionsAsked)/10"
    }
    
    private func setupButtonActions() {
        firstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func blockButtons(){
        firstButton.isEnabled = false
        secondButton.isEnabled = false
        thirdButton.isEnabled = false
    }
    
    private func unblockButtons(){
        firstButton.isEnabled = true
        secondButton.isEnabled = true
        thirdButton.isEnabled = true
    }
    
    private func updateButtonState(_ sender: UIButton, isCorrect: Bool) {
        blockButtons()
        sender.layer.borderWidth = 2
        sender.layer.borderColor = isCorrect ? UIColor(resource: .greenU).cgColor : UIColor(resource: .redU).cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            sender.layer.borderWidth = 0
            self.unblockButtons()
            if questionsAsked < 10 {
                self.updateWord()
            }
            else {
                self.showResultsAlert()
            }
        }
    }
    
    private func showResultsAlert() {
        let model = AlertModel(title: nil,
                               message: "Your result: \(correctAnswers)/10.",
                               button1Text: "Play again",
                               completion1: { [weak self] in
            AppReviewService.shared.checkAndRequestReview()
            self?.resetGame()
        },
                               button2Text: "Select group",
                               completion2: { [weak self] in
            AppReviewService.shared.checkAndRequestReview()
            self?.navigationController?.popViewController(animated: true)
        })
        alertPresenter?.showResultAlert(with: model)
    }
    
    private func resetGame() {
        questionsAsked = 0
        correctAnswers = 0
        getWords {
            self.updateWord()
        }
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text, let correctWord = correctWord?.en {
            let isCorrect = buttonText == correctWord
            if isCorrect {
                correctAnswers += 1
            }
            updateButtonState(sender, isCorrect: isCorrect)
        }
    }
}
