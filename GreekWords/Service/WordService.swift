import Foundation

final class WordService {
    static let jsonService = JsonService()
    private (set) var vocabulary: Vocabulary?
    private (set) var words: [Word] = []
    private (set) var currentRoundWords: [Word] = []
    
    private func loadVocabulary() {
        vocabulary = WordService.jsonService.getDataFromFile(name: "words")
    }
    
    private func getWords() {
        if let vocabularyData = vocabulary?.vocabulary {
            words = vocabularyData.groups.flatMap { $0.words }
            currentRoundWords = Array(words.shuffled().prefix(10))
        }
        print(currentRoundWords)
    }
    
    private func getWords(in group: String) {
        if let vocabularyData = vocabulary?.vocabulary {
            words = vocabularyData.groups
                .first { $0.name == group }
                .flatMap { $0.words } ?? []
            currentRoundWords = Array(words.shuffled().prefix(10))
        }
        print(currentRoundWords)
    }
}
