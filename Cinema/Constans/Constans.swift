//
//  Constans.swift
//  Cinema
//
//  Created by Helen on 19.10.2023.
//

import Foundation
import SwiftUI

struct Constants {
    static var screenSize = UIScreen.main.bounds
    static let baseImgUrl = "https://image.tmdb.org/t/p/w500/"
    static let baseMovieUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "32459ffc2aa33f5e14aa3075ed93fbfa"
    
    static func imageURL(path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: baseImgUrl + path)
    }
}
