import SwiftUI
import Combine

enum State {
    case empty
    case results
    
    var hasResults: Bool {
        switch self {
        case .results:
            return true
        case .empty:
            return false
        }
    }
}

final class SearchViewModel: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    var cancellable: Cancellable?
    
    private(set) var movies = [MovieCellViewModel]() {
        didSet {
            didChange.send(())
        }
    }
    
    private(set) var state = State.empty {
        didSet {
            didChange.send(())
        }
    }
    
    var textInput: String = "" {
        didSet {
            didChange.send(())
        }
    }
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func search() {
        let endpoint = API.Endpoint.search(term: textInput)
        let searchResource = Resource(baseURL: API.baseURL,
                                      path: endpoint.path,
                                      method: endpoint.method,
                                      query: endpoint.query)
                
        cancellable = session.request(request: searchResource.request())
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { [weak self] in
                if $0.results.count > 0 { self?.state = .results }
                return $0.results.map { MovieCellViewModel(movie: $0) }
            }
            .replaceError(with: [])
            .assign(to: \.movies, on: self)
    }
}
