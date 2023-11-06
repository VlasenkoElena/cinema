//
//  ContentViewModel.swift
//  Cinema
//
//  Created by Helen on 17.10.2023.
//

import Foundation

final class UpcomingViewModel: ObservableObject {
    
    private let networkManager = NetworkManager()
    var totalPages = 0
    var page : Int = 1
    
    enum State {
        case loading, loaded, error(String)
    }
    
    @Published var state: State = .loading
    
    private(set) var movies: [Movie] = []
    
    
    init() {
        fetch()
    }
    
    func fetch() {
        networkManager.fetchUpcoming(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultPopularMovies):
                self.movies += resultPopularMovies.results
                self.state = .loaded
                self.page = resultPopularMovies.page
                self.totalPages = resultPopularMovies.totalPages
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func loadMoreContent(currentItem: Movie) {
        if case .loading = state {
            return
        }
        if currentItem.id == movies.last?.id {
            page += 1
            fetch()
        }
    }
}
