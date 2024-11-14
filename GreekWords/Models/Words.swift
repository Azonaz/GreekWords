import Foundation

struct Vocabulary: Codable {
    let vocabulary: VocabularyData
}

struct VocabularyData: Codable {
    let groups: [VocabularyGroup]
}

struct VocabularyGroup: Codable {
    let name: String
    let words: [Word]
}

// swiftlint:disable identifier_name
// swiftlint:disable nesting
struct Word: Codable {
    let gr: String
    let en: String
}

struct VocabularyWordDay: Codable {
    let vocabulary: VocabularyData

    struct VocabularyData: Codable {
        let words: [Word]

        struct Word: Codable {
            let gr: String
            let en: String
        }
    }
// swiftlint:enable identifier_name
// swiftlint:enable nesting
}
