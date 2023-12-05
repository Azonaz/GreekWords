import Foundation

final class JsonService {
    
    func getDataFromFile(name: String) -> Vocabulary? {
        guard let jsonData = readLocalFile(forName: name) else {
            print("No data in json")
            return nil
        }

        do {
            let decodedData = try JSONDecoder().decode(Vocabulary.self, from: jsonData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }

    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }

        return nil
    }
}
