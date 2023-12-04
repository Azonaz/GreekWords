import UIKit

class GreekWordViewController: UIViewController {
    
    private let jsonService = JsonService()
    private var vocabulary: Vocabulary?
    private var words: [Word] = []
    private var currentRoundWords: [Word] = []
    private var correctWord: Word?
    private var questionsAsked = 0
    private var correctAnswers = 0
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .whiteDN)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.layer.borderWidth = 3
        label.layer.borderColor = UIColor(resource: .blackDN).cgColor
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Select correct option"
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = UIColor(resource: .whiteDN)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "1/10"
        label.textColor = UIColor(resource: .blackDN)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fisrtButton: UIButton = {
        let button = UIButton()
        button.setTitle("First", for: .normal)
        button.setTitleColor(UIColor(resource: .blackDN), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .blackDN).cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Second", for: .normal)
        button.setTitleColor(UIColor(resource: .blackDN), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .blackDN).cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.setTitle("Third", for: .normal)
        button.setTitleColor(UIColor(resource: .blackDN), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .blackDN).cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fisrtButton, secondButton, thirdButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDN)
        setupView()
        loadVocabulary()
        getWords()
        updateWord()
        setupButtonActions()
    }
    
    private func setupView() {
        view.addSubview(wordLabel)
        view.addSubview(countLabel)
        view.addSubview(infoLabel)
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            wordLabel.heightAnchor.constraint(equalToConstant: 150),
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 100),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 50),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    private func loadVocabulary() {
            vocabulary = jsonService.getDataFromFile(name: "words")
        }
    
    private func getWords() {
        if let vocabularyData = vocabulary?.vocabulary {
                words = vocabularyData.groups.flatMap { $0.words }
                currentRoundWords = Array(words.shuffled().prefix(10))
            }
            print(currentRoundWords)
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
        fisrtButton.setTitle(options[0].en, for: .normal)
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
            fisrtButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            secondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            thirdButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    
    private func blockButtons(){
        fisrtButton.isEnabled = false
        secondButton.isEnabled = false
        thirdButton.isEnabled = false
    }
    
    private func unblockButtons(){
        fisrtButton.isEnabled = true
        secondButton.isEnabled = true
        thirdButton.isEnabled = true
    }
    
    private func updateButtonState(_ sender: UIButton, isCorrect: Bool) {
        blockButtons()
        sender.layer.borderWidth = 2
        sender.layer.borderColor = isCorrect ? UIColor(resource: .greenU).cgColor : UIColor(resource: .redU).cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(resource: .blackDN).cgColor
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
         let alert = UIAlertController(
             title: "Результат",
             message: "Ваш результат \(correctAnswers)/10.",
             preferredStyle: .alert
         )
         let playAgainAction = UIAlertAction(title: "Сыграть еще", style: .default) { [weak self] _ in
             self?.resetGame()
         }
         alert.addAction(playAgainAction)
         present(alert, animated: true, completion: nil)
     }
    
    private func resetGame() {
          questionsAsked = 0
          correctAnswers = 0
        getWords()
          updateWord()
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
