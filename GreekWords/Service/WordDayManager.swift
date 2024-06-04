import UIKit

final class WordDayManager {
    private var viewController: ChooseTypeViewController
    private let wordService = WordService()
    private var article = ""
    private var greekWord = ""
    private var labelArray: [UILabel] = []
    private var lastLabelValue: String?
    private(set) var dayOfMonth: Int = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(viewController: ChooseTypeViewController) {
        self.viewController = viewController
    }
    
    func setWordForCurrentDate() {
        let calendar = Calendar.current
        dayOfMonth = calendar.component(.day, from: Date())
        wordService.loadWordDay { result in
            switch result {
            case .success(let vocabularyWordDay):
                DispatchQueue.main.async {
                    let validIndex = max(0, min(self.dayOfMonth - 1, vocabularyWordDay.vocabulary.words.count - 1))
                    self.viewController.grWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].gr
                    self.viewController.enWordLabel.text = vocabularyWordDay.vocabulary.words[validIndex].en
                    if let lastPlayedDateString = UserDefaults.standard.string(forKey: "lastPlayedDate"),
                       let lastPlayedDate = self.dateFormatter.date(from: lastPlayedDateString),
                       calendar.isDateInToday(lastPlayedDate) {
                        self.viewController.wordContainView.isHidden = false
                    } else {
                        self.viewController.wordContainView.isHidden = true
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
        if components.count > 1 {
            let firstPart = components.dropLast().joined(separator: " ")
            let secondPart = components.last!
            let shuffledCharacters = secondPart.shuffled()
            shuffledDayWord = String(shuffledCharacters)
            article = firstPart
            greekWord = secondPart
        } else {
            let shuffledCharacters = originalWord.shuffled()
            shuffledDayWord = String(shuffledCharacters)
            article = ""
            greekWord = originalWord
        }
        addLetterStackView(shuffledDayWord)
        addLetterButtonStackView(shuffledDayWord)
    }
    
    private func addLetterStackView(_ shuffledDayWord: String) {
        viewController.letterStackView.subviews.forEach { $0.removeFromSuperview() }
        for _ in shuffledDayWord {
            let letterLabel = WordLabel()
            labelArray.append(letterLabel)
            viewController.letterStackView.addArrangedSubview(letterLabel)
        }
        viewController.createLabelView()
    }
    
    private func addLetterButtonStackView(_ shuffledDayWord: String) {
        viewController.letterButtonStackView.subviews.forEach { $0.removeFromSuperview() }
        for char in shuffledDayWord {
            let letterButton = LetterButton()
            letterButton.setTitle(String(char), for: .normal)
            letterButton.addTarget(self, action: #selector(letterButtonTapped(_:)), for: .touchUpInside)
            viewController.letterButtonStackView.addArrangedSubview(letterButton)
        }
        viewController.createButtonView()
    }
    
    private func addTextToLabels(_ text: String) {
        guard let nextLabel = self.labelArray.first(where: { $0.text == "" }) else {
            return
        }
        nextLabel.text = text
        viewController.view.layoutIfNeeded()
    }
    
    private func checkOkButton() {
        viewController.okButton.isEnabled = !labelArray.contains { $0.text == "" }
    }
    
    private func clearLabels() {
        for label in labelArray {
            label.text = ""
        }
    }
    
    private func enableLetterButtons() {
        for button in viewController.letterButtonStackView.arrangedSubviews {
            guard let letterButton = button as? LetterButton else {
                continue
            }
            letterButton.isEnabled = true
            letterButton.setTitleColor(.blackDN, for: .normal)
        }
    }
    
    private func hideGame() {
        viewController.letterStackView.isHidden = true
        viewController.letterButtonStackView.isHidden = true
        viewController.okButton.isHidden = true
        viewController.helpEnLabel.isHidden = true
        viewController.articleLabel.isHidden = true
        viewController.backButton.isHidden = true
        viewController.helpButton.isHidden = true
        viewController.wordContainView.isHidden = false
    }
    
    func tapHelpButton() {
        viewController.articleLabel.text = article
        viewController.articleLabel.isHidden = false
        viewController.helpEnLabel.text = viewController.enWordLabel.text
        viewController.helpEnLabel.isHidden = false
    }
    
    func tapBackButton() {
        guard let lastLabel = labelArray.last(where: { $0.text != nil && !$0.text!.isEmpty }) else {
            return
        }
        lastLabelValue = lastLabel.text
        lastLabel.text?.removeLast()
        for (_, button) in viewController.letterButtonStackView.arrangedSubviews.enumerated() {
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
    
    func tapOkButton() {
        let enteredWord = labelArray.compactMap { $0.text }.joined()
        let isCorrect = enteredWord == greekWord
        for label in labelArray {
            if isCorrect {
                label.layer.borderColor = UIColor.greenU.cgColor
                tapHelpButton()
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
    
    @objc private func letterButtonTapped(_ sender: LetterButton) {
        guard let tappedText = sender.title(for: .normal) else {
            return
        }
        addTextToLabels(tappedText)
        sender.isEnabled = false
        sender.setTitleColor(.lightGray, for: .normal)
        checkOkButton()
    }
}
