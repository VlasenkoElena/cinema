//
//  Extensions+Double.swift
//  Cinema
//
//  Created by Helen on 19.10.2023.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
