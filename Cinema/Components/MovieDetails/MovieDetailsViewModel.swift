//
//  MovieDetailsViewModel.swift
//  Cinema
//
//  Created by Helen on 18.10.2023.
//

import Foundation

final class MovieDetailsViewModel: ObservableObject {
    private let networkManager = NetworkManager()
    
    enum State {
        case loading, loaded, error(String)
    }
    
    enum MovieType {
        case movie, series
    }
    
    enum EpisodeType {
        case standard, finale
    }
    
    @Published var state: State = .loading
    var movie: Movie
    var movieType: MovieType
    
    var genres: [Genre] {
        movie.genres ?? []
    }
    
    var trailer: String? {
        let baseUrl = "https://youtube.com/watch?v="
        guard let trailer = movie.videos?.results.first(where: {$0.type == .trailer}) else {
            return nil
        }
        return baseUrl + trailer.key
    }
    
    var raiting: String {
        let voteAverage: Double = movie.voteAverage ?? 0.0
        return "\(voteAverage.rounded(toPlaces: 1))"
    }
    
    var releaseYear: String? {
        guard let releaseData = movie.releaseDate ?? movie.firstAirDate else {
            return nil
        }
        
        return releaseData.date(
            fromFormat: "yyyy-MM-dd",
            toFormat: "yyyy"
        )
    }
    
    var runtime: (hours: Int , leftMinutes: Int)? {
        guard let runtime = movie.runtime else {
            return nil
        }
       return minutesToHoursAndMinutes(runtime)
    }
    
    var nextEpisode: String? {
        movie.nextEpisodeToAir?.airDate?.date(
            fromFormat: "yyyy-MM-dd",
            toFormat: "EEEE, d MMMM"
        )
    }
    
    var finaleEpisode: String? {
        if movie.lastEpisodeToAir?.episodeType == "finale" {
            return movie.lastEpisodeToAir?.airDate?.date(
                fromFormat: "yyyy-MM-dd",
                toFormat: "yyyy"
            )
        } else {
            return ""
        }
    }
    
    var homePage: URL? {
       return URL(string: movie.homepage ?? "")
    }
    
    init(movie: Movie, movieType: MovieType) {
        self.movie = movie
        self.movieType = movieType
        configur()
    }
    
    func configur() {
        switch movieType {
        case .movie:
            fetchMovie()
        case .series:
            fetchSeriels()
        }
    }
    
    func fetchMovie() {
        state = .loading
        networkManager.fetchMovie(movieId: movie.id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.state = .loaded
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSeriels() {
        state = .loading
        networkManager.fetchSerielsDetails(serielsId: movie.id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.state = .loaded
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
                print(error)
            }
        }
    }
    
    private func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
}
