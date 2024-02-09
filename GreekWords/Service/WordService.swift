import Foundation

final class WordService {
    
    private let service = NetworkService()
    private var vocabulary: Vocabulary?
    private var dictionaryUrl = "https://find-friends-team.ru/words-gr-a1.json"
    
    func loadVocabulary(handler: @escaping (Result<Vocabulary, Error>) -> Void) {
        guard let url = URL(string: dictionaryUrl) else { return }
        service.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let vocabulary = try JSONDecoder().decode(Vocabulary.self, from: data);
                    handler(.success(vocabulary))
                } catch {
                    handler(.failure(error))
                }
            case .failure (let error):
                handler(.failure(error))
            }
        }
    }
    
    func getGroups(handler: @escaping (Result<[VocabularyGroup], Error>) -> Void) {
        loadVocabulary { result in
            switch result {
            case .success(let vocabulary):
                handler(.success(vocabulary.vocabulary.groups))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func getAllWordsForRandom(completion: @escaping ([Word]) -> Void) {
        loadVocabulary { result in
            switch result {
            case .success(let vocabulary):
                let allWords = vocabulary.vocabulary.groups.flatMap { $0.words }
                completion(allWords)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func getRandomWordsForAll(count: Int, completion: @escaping ([Word]) -> Void) {
        getAllWordsForRandom { allWords in
            let randomWords = Array(allWords.shuffled().prefix(count))
            completion(randomWords)
        }
    }
    
    
    func getWords(for group: VocabularyGroup) -> [Word] {
        return group.words
    }
    
    
    
    func getRandomWords(for group: VocabularyGroup, count: Int) -> [Word] {
        let allWords = getWords(for: group)
        return Array(allWords.shuffled().prefix(count))
    }
}
