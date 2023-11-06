//
//  ActorsView.swift
//  Cinema
//
//  Created by Helen on 20.10.2023.
//

import SwiftUI
import Kingfisher

struct ActorsView: View {
    @StateObject var viewModel: ActorsViewModel
    @State private var showingFullImage = false
    @State private var imgUrl = ""
    
    init(id: Int) {
        self._viewModel = .init(wrappedValue: ActorsViewModel(id: id))
    }
    
    var body: some View {
        ScrollView {
                VStack {
                    KFImage(Constants.imageURL(path: viewModel.actor?.profilePath))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    HStack {
                        Text(viewModel.actor?.name ?? "")
                            .bold()
                            .font(.title3)
                        Text(viewModel.birthday ?? "")
                            .foregroundColor(Colors.darkCharcoal.sui)
                    }
                    
                    Text(viewModel.actor?.biography ?? "")
                        .foregroundColor(.secondary)
                        .padding()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.images, id: \.self) { image in
                                KFImage(Constants.imageURL(path: image.filePath))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .onTapGesture {
                                            showingFullImage = true
                                            imgUrl = image.filePath
                                        }
                            }
                        }
                    }
                    .padding()
            }
        }
        .sheet(isPresented: $showingFullImage) {
            ImageView(imgSelected: $imgUrl)
        }
      
    }
}

