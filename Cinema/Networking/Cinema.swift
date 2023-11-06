//
//  Cinema.swift
//  Cinema
//
//  Created by Helen on 17.10.2023.
//

import Foundation

struct ResultPopularMovies: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    let dates: Dates?
    
    enum CodingKeys: String, CodingKey {
        case page, results, dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Movie: Codable, Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int
    let originalLanguage: String?
    let originalTitle, overview, originalName: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdbID: String?
    let revenue, runtime: Int?
    let status, tagline: String?
    let videos: Videos?
    let originCountry: [String]?
    let nextEpisodeToAir: EpisodeToAir?
    let firstAirDate: String?
    let name: String?
    let lastEpisodeToAir: EpisodeToAir?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage
        case imdbID = "imdb_id"
        case revenue, runtime
        case status, tagline
        case videos
        case originalName = "original_name"
        case originCountry = "origin_country"
        case nextEpisodeToAir = "next_episode_to_air"
        case firstAirDate = "first_air_date"
        case name
        case lastEpisodeToAir = "last_episode_to_air"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case ko = "ko"
    case pt = "pt"
}

struct BelongsToCollection: Codable {
    let id: Int
    let name, posterPath, backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

struct Videos: Codable {
    let results: [Video]
}

// MARK: - Video
struct Video: Codable {
    let iso639_1: OriginalLanguage
    let iso3166_1: OriginCountry
    let name, key: String
    let site: Site
    let size: Int
    let type: TypeEnum
    let official: Bool
    let publishedAt, id: String
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}
enum OriginCountry: String, Codable {
    case us = "US"
}

struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - EpisodeToAir
struct EpisodeToAir: Codable {
    let id: Int
    let name, overview: String?
    let voteAverage: Double?
    let voteCount: Int?
    let airDate: String?
    let episodeNumber: Int?
    let episodeType, productionCode: String?
    let seasonNumber, showID: Int?
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}
