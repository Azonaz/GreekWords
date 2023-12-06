import Foundation

final class NetworkService {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    handler(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    handler(.failure(NetworkError.codeError))
                    return
                }
                if (200 ..< 300).contains(httpResponse.statusCode) {
                    if let data = data {
                        handler(.success(data))
                    } else {
                        handler(.failure(NetworkError.codeError))
                    }
                } else {
                    handler(.failure(NetworkError.codeError))
                }
            }
        }
        task.resume()
    }
}

