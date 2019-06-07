import Foundation
import Combine

enum RequestError: Error {
    case request(code: Int, error: Error?)
    case unknown
}

extension URLSession {
    
    func request(request: URLRequest) -> AnyPublisher<Data,RequestError> {
        return AnyPublisher<Data,RequestError> { subscriber in
            
            let task = self.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let _ = response {
                        let _ = subscriber.receive(data)
                        subscriber.receive(completion: .finished)
                    } else {
                        subscriber.receive(completion: .failure(.unknown))
                    }
                }
            }
            
            task.resume()
        }
    }
}

extension JSONDecoder: TopLevelDecoder {}

