//
//  HomeViewModel.swift
//  Cinema
//
//  Created by Helen on 23.10.2023.
//

import Foundation

@MainActor final class HomeViewModel: ObservableObject {
    
    private let networkManager = NetworkManager()
    var totalMoviePages = 0
    var moviePage : Int = 1
    
    var totalSeriesPages = 0
    var seriesPage : Int = 1
    
    var totalActorsPages = 0
    var actorPage : Int = 1
    
    enum State {
        case loading, loaded, error(String)
    }
    
    @Published var state: State = .loading
    private(set) var movies: [Movie] = []
    private(set) var series: [Movie] = []
    private(set) var actors: [Actor] = []
    
    init() {
        Task {
            await fetchPopularMovie()
            await fetchSeries()
            await fetchActors()
        }
    }
    
    func fetchPopularMovie() async {
        let result = await networkManager.fetchPopular(page: moviePage)
        switch result {
        case .success(let resultPopularMovies):
            movies += resultPopularMovies.results
            moviePage = resultPopularMovies.page
            totalMoviePages = resultPopularMovies.totalPages
            state = .loaded
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
    
    func fetchSeries() async {
        let result = await networkManager.fetchTvSeries(page: seriesPage)
        switch result {
        case .success(let series):
            self.series = series.results
            seriesPage = series.page
            totalSeriesPages = series.totalPages
            state = .loaded
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
        
    }
    
    func fetchActors() async {
        let result = await networkManager.fetchActors(page: actorPage)
        switch result {
        case .success(let actors):
            self.actors = actors.results
            state = .loaded
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
        
    }
    
    func loadMoreMovie(currentItem: Movie) async {
        if case .loading = state {
            return
        }
        if currentItem.id == movies.last?.id {
            moviePage += 1
            await fetchPopularMovie()
        }
    }
    
    func loadMoreSeriels(currentItem: Movie) async {
        if case .loading = state {
            return
        }
        if currentItem.id == series.last?.id {
            seriesPage += 1
           await fetchSeries()
        }
    }
    
    func loadMoreActors(currentItem: Actor) async {
        if case .loading = state {
            return
        }
        if currentItem.id == actors.last?.id {
            moviePage += 1
            await fetchActors()
        }
    }
    
    func getRaiting(movie: Movie) -> String {
        guard let voteAverage = movie.voteAverage?.rounded(toPlaces: 1) else {
            return ""
        }
        return String(voteAverage)
    }
    
}
