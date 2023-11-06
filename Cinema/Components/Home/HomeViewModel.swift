//
//  HomeViewModel.swift
//  Cinema
//
//  Created by Helen on 23.10.2023.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
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
        fetchPopularMovie()
        fetchSeries()
        fetchActors()
    }
    
    func fetchPopularMovie() {
        networkManager.fetchPopular(page: moviePage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultPopularMovies):
                self.movies += resultPopularMovies.results
                self.moviePage = resultPopularMovies.page
                self.totalMoviePages = resultPopularMovies.totalPages
                self.state = .loaded
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func fetchSeries() {
        networkManager.fetchTvSeries(page: seriesPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let series):
                self.series = series.results
                self.seriesPage = series.page
                self.totalSeriesPages = series.totalPages
                self.state = .loaded
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func fetchActors() {
        networkManager.fetchActors(page: actorPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let actors):
                self.actors = actors.results
                self.state = .loaded
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func loadMoreMovie(currentItem: Movie) {
        if case .loading = state {
            return
        }
        if currentItem.id == movies.last?.id {
            moviePage += 1
            fetchPopularMovie()
        }
    }
    
    func loadMoreSeriels(currentItem: Movie) {
        if case .loading = state {
            return
        }
        if currentItem.id == series.last?.id {
            seriesPage += 1
            fetchSeries()
        }
    }
    
    func loadMoreActors(currentItem: Actor) {
        if case .loading = state {
            return
        }
        if currentItem.id == actors.last?.id {
            moviePage += 1
            fetchActors()
        }
    }
    
    func getRaiting(movie: Movie) -> String {
        guard let voteAverage = movie.voteAverage?.rounded(toPlaces: 1) else {
            return ""
        }
        return String(voteAverage)
    }
    
}
