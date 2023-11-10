//
//  RaitingView.swift
//  Cinema
//
//  Created by Helen on 08.11.2023.
//

import SwiftUI
import Kingfisher

struct RaitingView: View {
    
    @Binding var movie: Movie?
    @Environment(\.dismiss) var dismiss
    
    @State var isDiscard = false
    @State var rating: Int
    var maximumRating = 10
    
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.white
    var onColor = Color.blue
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            KFImage(Constants.imageURL(path: movie?.posterPath))
                .resizable()
                .ignoresSafeArea(.all)
                .background(.thinMaterial)
                .blur(radius: 20)
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea(.all)
         
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        if rating != 0 {
                            isDiscard = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Label("", systemImage: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                .padding()
                
                KFImage(Constants.imageURL(path: movie?.posterPath))
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 250)
                
                Text("How would you rate \(movie?.title ?? movie?.name ?? "")?")
                    .foregroundColor(.white)
                    .frame(width: 350)
                    .multilineTextAlignment(.center)
                    .padding()
                    .bold()
                
                HStack {
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        image(for: number)
                            .foregroundColor(number > rating ? offColor : onColor)
                            .font(.system(size: 20))
                            .onTapGesture {
                                rating = number
                            }
                    }
                }
                .padding()
                
                Button("Rate") {
                    dismiss()
                }
                .frame(width: 200, height: 30, alignment: .center)
                .background(rating != 0 ? .blue : .secondary)
                .foregroundColor(.white)
                .bold()
                .padding()
            }
        }
        .alert("Are you sure you want to discard?", isPresented: $isDiscard) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}
