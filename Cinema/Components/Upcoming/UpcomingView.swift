//
//  ContentView.swift
//  Cinema
//
//  Created by Helen on 16.10.2023.
//

import SwiftUI
import Kingfisher

struct UpcomingView: View {
    @StateObject var viewModel: UpcomingViewModel = .init()
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loaded:
                contentView
            case .loading:
                ProgressView()
            case .error(let text):
                Text(text)
            }
        }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 2 - 15))
    ]
    
    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailsView(movie: movie, movieType: .movie)
                    } label: {
                        KFImage(Constants.imageURL(path: movie.posterPath))
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    .onAppear {
                        Task {
                           await viewModel.loadMoreContent(currentItem: movie)
                        }
                     }
                }
            }
        }
        .navigationTitle(title)
    }
    
    var title: String {
        "Upcoming:"
    }
}

