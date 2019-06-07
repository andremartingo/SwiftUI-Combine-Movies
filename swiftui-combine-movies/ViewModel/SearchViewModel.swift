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

protocol SearchViewModelType {
    var movies: [Movie] { get }
    var movieImages: [Movie: UIImage] { get }
    var state: State { get }
    var textInput: String { get set }
}

final class SearchViewModel: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    var cancellable: Cancellable?
    
    private(set) var movies = [Movie]() {
        didSet {
            didChange.send(())
        }
    }
    
    private(set) var movieImages = [Movie: UIImage]() {
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
    
    func search() {
        let endpoint = API.Endpoint.search(term: textInput)
        let searchResource = Resource(baseURL: API.baseURL,
                                      path: endpoint.path,
                                      method: endpoint.method,
                                      query: endpoint.query)
                
        cancellable = URLSession.shared.request(request: searchResource.request())
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { [weak self] in
                if $0.results.count > 0 { self?.state = .results }
                return $0.results
            }
            .replaceError(with: [])
            .assign(to: \.movies, on: self)
    }
    
    func getImage(for movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        let endpoint = API.Endpoint.image(id: posterPath, size: API.ImageSize.small)
        let imageResource = Resource(baseURL: API.imageURL,
                                     path: endpoint.path,
                                     method: endpoint.method,
                                     query: endpoint.query)
        let _ = URLSession.shared.request(request: imageResource.request())
            .map(UIImage.init)
            .replaceError(with: nil)
            .sink { [weak self] image in
                self?.movieImages[movie] = image
            }
    }
}
