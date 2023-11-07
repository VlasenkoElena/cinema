//
//  HomeView.swift
//  Cinema
//
//  Created by Helen on 23.10.2023.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init()
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                popular
                tvSeries
                actors
            }
        }
    }
    
    private var popular: some View {
        VStack {
            HStack {
                Text("Popular:").font(.system(.title, weight: .bold))
                Spacer()
            }.padding()
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.movies, id: \.id) { movie in
                        VStack {
                            NavigationLink {
                                MovieDetailsView(movie: movie, movieType: .movie)
                            } label: {
                                KFImage(Constants.imageURL(path: movie.posterPath))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 300)
                            }
                            
                            HStack() {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(viewModel.getRaiting(movie: movie))
                                    .font(.system(size: 12, weight: .bold))
                                Spacer()
                            }
                            .padding(5)
                        }
                        .background(Colors.cardColor.sui)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .shadow(color: Colors.shadowColor.sui, radius: 2, x: 2, y: 2)
                        .padding(.leading, 10)
                        .onAppear {
                            Task {
                               await viewModel.loadMoreMovie(currentItem: movie)
                            }
                        }
                    }
                }
            }.frame(height: 350)
        }
    }
    
    private var tvSeries: some View {
        VStack {
            HStack {
                Text("TV Series:").font(.system(.title, weight: .bold))
                Spacer()
            }.padding()
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.series) { seriel in
                        VStack {
                            NavigationLink {
                                MovieDetailsView(movie: seriel, movieType: .series)
                            } label: {
                                KFImage(Constants.imageURL(path: seriel.posterPath))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 150)
                            }
                            
                            HStack() {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .foregroundColor(.yellow)
                                    .frame(width: 8, height: 8)
                                Text(viewModel.getRaiting(movie: seriel))
                                    .font(.system(size: 10, weight: .bold))
                                Spacer()
                            }
                            .padding(4)
                        }
                        .background(Colors.cardColor.sui)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .shadow(color: Colors.shadowColor.sui, radius: 2, x: 2, y: 2)
                        .padding(.leading, 15)
                        .onAppear {
                            Task {
                               await viewModel.loadMoreSeriels(currentItem: seriel)
                            }
                        }
                    }
                }
            }.frame(height: 200)
        }
    }
    
    private var actors: some View {
        VStack {
            HStack {
                Text("Top actors:").font(.system(.title, weight: .bold))
                Spacer()
            }.padding()
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.actors, id: \.id) { item in
                        NavigationLink {
                           ActorsView(id: item.id)
                        } label: {
                            KFImage(Constants.imageURL(path: item.profilePath))
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                .padding(.horizontal, 10)
                        }
                        .onAppear {
                            Task {
                               await viewModel.loadMoreActors(currentItem: item)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PopularityView: View {
    var progress = Double.random(in: 0...1)
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(
                    Color(UIColor(red: 0.01, green: 0.54, blue: 0.06, alpha: 0.4)),
                    lineWidth: 5
            )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(UIColor(red: 0.01, green: 0.54, blue: 0.06, alpha: 1.0)),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            // 1
                .animation(.easeOut, value: progress)
            
            Text("\(progress * 100, specifier: "%.0f") %")
                .font(.system(size: 8))
                .bold()
        }
        .frame(width: 25, height: 25)
    }
}
