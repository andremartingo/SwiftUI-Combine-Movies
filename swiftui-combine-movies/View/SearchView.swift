import SwiftUI

struct SearchView : View {
    
    @EnvironmentObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(input: $viewModel.textInput) {
                    self.viewModel.search()
                }
                
                List {
                    if viewModel.state.hasResults {
                        ForEach(viewModel.movies) { movie in
                            MovieCell(movie: movie)
                        }
                    } else {
                            Text("No Results")
                                .font(Font.system(size: 18).bold())
                    }
                }
            }.navigationBarTitle(Text("Movies"))
        }
    }
}
