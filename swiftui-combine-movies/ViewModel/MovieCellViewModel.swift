import Foundation
import SwiftUI
import Combine

final class MovieCellViewModel: Identifiable, BindableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    let title: String
    private(set) var image: UIImage? {
        didSet {
            didChange.send(())
        }
    }
    
    init(movie: Movie, session: URLSession = URLSession.shared) {
        self.title = movie.title
        
        if let posterPath = movie.posterPath {
            let endpoint = API.Endpoint.image(id: posterPath, size: API.ImageSize.small)
            let imageResource = Resource(baseURL: API.imageURL,
                                         path: endpoint.path,
                                         method: endpoint.method,
                                         query: endpoint.query)
            let _ = session.request(request: imageResource.request())
                .map(UIImage.init)
                .replaceError(with: nil)
                .sink { [weak self] image in
                    self?.image = image
                }
        }
    }
}
