//
//  NetworkManager.swift
//  Cinema
//
//  Created by Helen on 17.10.2023.
//

import Foundation
import Moya

enum EnvironmentBuild {
    case dev
    case production
}

enum NetworkService {
    case popular(Int), movie(Int), upcoming(Int), popularSeries(Int), person(Int), serialDetails(Int), actorDetails(Int), actorImages(Int)
    
}

extension NetworkService: TargetType {
    
    static var environment: EnvironmentBuild {
        return .dev
    }
    
    public var baseURL: URL {
        switch NetworkService.environment {
        case .production:
            return URL(string: "https://api.themoviedb.org/3/")!
        default:
            return URL(string: "https://api.themoviedb.org/3/")!
        }
    }
    
    public var path: String {
        switch self {
        case .popular: return "movie/popular"
        case .movie(let id): return "movie/\(id)"
        case .upcoming: return "movie/upcoming"
        case .popularSeries: return "tv/popular"
        case .person: return "person/popular"
        case .serialDetails(let id): return "tv/\(id)"
        case .actorDetails(let id): return "person/\(id)"
        case .actorImages(let id): return "person/\(id)/images"
        }
    }
    
    public var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    public var method: Moya.Method {
        switch self {
        case .popular: return .get
        case .movie: return .get
        case .upcoming: return .get
        case .popularSeries: return .get
        case .person: return .get
        case .serialDetails: return .get
        case .actorDetails: return .get
        case .actorImages: return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .popular(let page):
            return .requestParameters(
                parameters: ["page": page, "api_key": Constants.apiKey],
                encoding: URLEncoding.default
            )
        case .movie:
            return .requestParameters(parameters: ["api_key": Constants.apiKey, "append_to_response": "videos"], encoding: URLEncoding.default)
        case .upcoming(let page):
            return .requestParameters(parameters: ["page": page, "api_key": Constants.apiKey],
                                      encoding: URLEncoding.default)
        case .popularSeries(let page):
            return .requestParameters(parameters: ["page": page, "api_key": Constants.apiKey],
                                      encoding: URLEncoding.default)
        case .person(let page):
            return .requestParameters(parameters: ["page": page, "api_key": Constants.apiKey], encoding: URLEncoding.default)
        case .serialDetails:
            return .requestParameters(parameters: ["api_key": Constants.apiKey, "append_to_response": "videos"], encoding: URLEncoding.default)
        case .actorDetails:
            return .requestParameters(parameters: ["api_key": Constants.apiKey], encoding: URLEncoding.default)
        case .actorImages:
            return .requestParameters(parameters: ["api_key": Constants.apiKey], encoding: URLEncoding.default)
        }
    }
    
    
}

class BaseNetworkManager {
    
    let provider = MoyaProvider<NetworkService>(
        plugins:[
            NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (target, array) in
                if let log = array.first {
                    debugLog(log)
                }
            }, logOptions: .formatRequestAscURL))
        ]
    )
    
    func request<T: Codable>(target: NetworkService) async -> Result<T, Error>  {
        return await withCheckedContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: .success(result))
                    } catch {
                        continuation.resume(returning: .failure(error))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
}


final class NetworkManager: BaseNetworkManager {
    
    func fetchPopular(
        page: Int
    ) async -> Result<ResultPopularMovies, Error> {
       await request(target: .popular(page))
    }
    
    func fetchMovie(
        movieId: Int
    ) async -> Result<Movie, Error> {
       await request(target: .movie(movieId))
    }
    
    func fetchUpcoming(
        page: Int
    ) async -> Result<ResultPopularMovies, Error> {
       await request(target: .upcoming(page))
    }
    
    func fetchTvSeries(
        page: Int
    ) async -> Result<ResultPopularMovies, Error> {
       await request(target: .popularSeries(page))
    }
    
    func fetchActors(
        page: Int
    ) async -> Result<PopularActors, Error> {
       await request(target: .person(page))
    }
    
    func fetchSerielsDetails(
        serielsId: Int
    ) async -> Result<Movie, Error> {
       await request(target: .serialDetails(serielsId))
    }
    
    func fetchActorDetails(
        actorId: Int
    ) async -> Result<ActorDetails, Error> {
       await request(target: .actorDetails(actorId))
    }
    
    func fetchActorImages(
        actorId: Int
    ) async -> Result<ActorImages, Error> {
       await request(target: .actorImages(actorId))
    }
}

public func debugLog(
    _ item: Any...,
    filename: String = #file,
    line: Int = #line,
    funcname: String = #function
) {
#if DEBUG
    print(
        """
        🕗 \(Date())
        📄 \(filename.components(separatedBy: "/").last ?? "") \(line) \(funcname)
        ℹ️ \(item)
        """
    )
#endif
}

