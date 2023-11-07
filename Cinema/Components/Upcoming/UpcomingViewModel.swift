//
//  ContentViewModel.swift
//  Cinema
//
//  Created by Helen on 17.10.2023.
//

import Foundation

@MainActor final class UpcomingViewModel: ObservableObject {
    
    private let networkManager = NetworkManager()
    var totalPages = 0
    var page : Int = 1
    
    enum State {
        case loading, loaded, error(String)
    }
    
    @Published var state: State = .loading
    
    private(set) var movies: [Movie] = []
    
    
    init() {
        Task {
           await fetch()
        }
    }
    
    func fetch() async {
        let result = await networkManager.fetchUpcoming(page: page)
        switch result {
        case .success(let resultPopularMovies):
            movies += resultPopularMovies.results
            state = .loaded
            page = resultPopularMovies.page
            totalPages = resultPopularMovies.totalPages
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
        
    }
    
    func loadMoreContent(currentItem: Movie) async {
        if case .loading = state {
            return
        }
        if currentItem.id == movies.last?.id {
            page += 1
           await fetch()
        }
    }
}
