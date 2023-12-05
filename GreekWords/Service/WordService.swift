import Foundation

final class WordService {
    private let jsonService = JsonService()
    private var vocabulary: Vocabulary?
    
    func getGroups() -> [VocabularyGroup]? {
            guard let vocabulary = jsonService.getDataFromFile(name: "words")?.vocabulary else {
                return nil
            }
            return vocabulary.groups
        }
    
    func loadVocabulary() {
            vocabulary = jsonService.getDataFromFile(name: "words")
        }
        
        func getWords(for group: VocabularyGroup) -> [Word] {
            return group.words
        }
        
        func getRandomWords(for group: VocabularyGroup, count: Int) -> [Word] {
            let allWords = getWords(for: group)
            return Array(allWords.shuffled().prefix(count))
        }
}
