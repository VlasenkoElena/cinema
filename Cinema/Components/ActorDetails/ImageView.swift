//
//  ImageView.swift
//  Cinema
//
//  Created by Helen on 26.10.2023.
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    
    @Binding var imgSelected: String
    @Environment(\.dismiss) var dissmis
    
    var body: some View {
        KFImage(Constants.imageURL(path: imgSelected))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                dissmis()
            }
    }
}
