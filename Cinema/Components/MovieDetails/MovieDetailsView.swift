//
//  MovieDetailsView.swift
//  Cinema
//
//  Created by Helen on 18.10.2023.
//

import SwiftUI
import YouTubePlayerKit
import Kingfisher

struct MovieDetailsView: View {
    
    // MARK: - Properties -
    
    @StateObject var viewModel: MovieDetailsViewModel
    @State private var isShowRate = false
    @State private var selectedMovie: Movie?
    
    
    // MARK: - Init -
    
    init(movie: Movie, movieType: MovieDetailsViewModel.MovieType) {
        self._viewModel = .init(wrappedValue: MovieDetailsViewModel(movie: movie, movieType: movieType))
    }
    
    // MARK: - Body -
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text(viewModel.movie.title ?? viewModel.movie.name ?? "")
                    .font(.title3)
                    .bold()
                genres
                raiting
                player
                if viewModel.movieType == .series {
                    serielsRelease
                    nextEpisode
                } else {
                    releaseDate
                }
                overview
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Views -
    
    private var genres: some View {
        HStack {
            ForEach(viewModel.genres, id: \.id) { genre in
                Text(genre.name)
                .font(.subheadline)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.blackWhite.sui, lineWidth: 1)
                )
            }
        }
    }
    
    private var raiting: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            HStack(spacing: 0) {
                Text(viewModel.raiting)
                    .font(.system(size: 18, weight: .bold))
                Text("/10")
                    .font(.system(size: 15))
            }
            
            Spacer()
            
            Button {
                selectedMovie = viewModel.movie
                isShowRate.toggle()
            } label: {
                Label("Rate", systemImage: "star")
            }
            .fullScreenCover(isPresented: $isShowRate) {
                RaitingView(movie: $selectedMovie, rating: 0)
            }
        }
        .frame(width: 200)
        .padding()
    }
    
    @ViewBuilder
    private var releaseDate: some View {
        if let hours = viewModel.runtime?.hours, let leftMinutes = viewModel.runtime?.leftMinutes {
            HStack {
                Text(viewModel.releaseYear ?? "")
                Text(" • \(hours)h \(leftMinutes)m")
            }
        }
    }
    
    @ViewBuilder
    private var serielsRelease: some View {
        if let startYear = viewModel.releaseYear {
            HStack {
                Text("TV Series \(startYear) - \(viewModel.finaleEpisode ?? "")")
            }
        }
    }
    
    @ViewBuilder
    private var nextEpisode: some View {
        if viewModel.nextEpisode != nil {
            HStack() {
                Text("Next Episode")
                        .bold()
                        .foregroundColor(.secondary)
                    Text(viewModel.nextEpisode ?? "")
                    .foregroundColor(.secondary)
                }
                .padding()
                .border(.gray)
        }
    }
    
    @ViewBuilder
    private var homePage: some View {
        if let homePage = viewModel.homePage {
            HStack {
                Link("Home page", destination: homePage)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var overview: some View {
        HStack(alignment: .top) {
            KFImage(Constants.imageURL(path: viewModel.movie.posterPath))
                .resizable()
                .scaledToFit()
                .padding()
            Text(viewModel.movie.overview ?? "")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding()
        }
    }
    
    @ViewBuilder
    private var player: some View {
        switch viewModel.state {
        case .loaded:
            if let trailer = viewModel.trailer {
                YouTubePlayerView(YouTubePlayer(stringLiteral: trailer))
                    .frame(width: Constants.screenSize.width, height: Constants.screenSize.height * 0.3)
            }
        case .loading:
            ProgressView()
                .frame(width: Constants.screenSize.width, height: 30)
        default:
            EmptyView()
                .frame(height: 0)
        }
    }
}
